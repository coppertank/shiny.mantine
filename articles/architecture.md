# Architecture: Serialization, Reactive Props, and Reactive Output

``` r

library(shiny)
library(shiny.mantine)
```

This vignette explains how `shiny.mantine` actually works under the
hood: how R function calls become a React tree in the browser, how
updates flow back from R to already-mounted components, and the two
features that go beyond simple one-way rendering — a generic
reactive-props channel and a
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html)-equivalent
reactive output.

## Why an independent React runtime?

`shiny.mantine` is architecturally inspired by Appsilon’s
[shiny.react](https://github.com/Appsilon/shiny.react) — the general
idea of serializing props to JSON, syncing input values via
`Shiny.setInputValue()`, and loading assets through an `htmlDependency`
is the same. But it does **not** reuse `shiny.react`’s compiled
JavaScript runtime or its React copy.

The reason is a version conflict: Mantine v9 requires React \>= 19.2,
while `shiny.react` shares a single React 18.3.1 copy across every
package that uses its `externals` mechanism. Mounting two different
React copies in the same page causes hook-dispatcher conflicts (“Invalid
hook call”) — see
[Appsilon/shiny.react#87](https://github.com/Appsilon/shiny.react/issues/87).
So `shiny.mantine` bundles its own React 19 / ReactDOM 19 copy inside
`inst/www/mantine.js`, completely independent from `shiny.react`’s
runtime, with its own small mount and input-sync layer reimplementing
the same concepts.

## From R call to React element

Every component wrapper is a thin call to one of two internal helpers in
`R/mantine-element.R`:

``` r

# displayComponent() is used for components with no special behavior:
# it just forwards whatever arguments it receives.
Card
#> function (...) 
#> mantineElement(name, ...)
#> <bytecode: 0x55768e779170>
#> <environment: 0x55768e77a0f8>
```

``` r

# Some components validate/transform an argument before forwarding it —
# e.g. Button() requires both a label and an inputId.
Button
#> function (label, inputId, ...) 
#> {
#>     mantineElement("Button", label, inputId = inputId, ...)
#> }
#> <bytecode: 0x55768eabec08>
#> <environment: namespace:shiny.mantine>
```

Both ultimately call `mantineElement()`, which builds a plain,
serializable tree —
`list(type = "element", name = <string>, props = <list>)` — tagged with
the S3 class `mantine_element`:

``` r

btn <- Button("Click me", inputId = "btn1", color = "blue")
str(unclass(btn))
#> List of 3
#>  $ type : chr "element"
#>  $ name : chr "Button"
#>  $ props:List of 3
#>   ..$ inputId :List of 2
#>   .. ..$ type : chr "raw"
#>   .. ..$ value: chr "btn1"
#>   ..$ color   :List of 2
#>   .. ..$ type : chr "raw"
#>   .. ..$ value: chr "blue"
#>   ..$ children:List of 2
#>   .. ..$ type : chr "raw"
#>   .. ..$ value: chr "Click me"
```

Each prop value is recursively normalized by `toMantineData()` into one
of a small set of tagged shapes (`raw`, `array`, `object`, `element`,
`html`) that the JS side’s `buildElement()`/`buildProps()`
(`js/src/serialization.js`) knows how to turn back into real React
elements or plain JS values:

``` r

card <- Card(withBorder = TRUE, Text("Hello"))
str(unclass(card), max.level = 3)
#> List of 3
#>  $ type : chr "element"
#>  $ name : chr "Card"
#>  $ props:List of 2
#>   ..$ withBorder:List of 2
#>   .. ..$ type : chr "raw"
#>   .. ..$ value: logi TRUE
#>   ..$ children  :List of 3
#>   .. ..$ type : chr "element"
#>   .. ..$ name : chr "Text"
#>   .. ..$ props:List of 1
```

Nesting works exactly like `htmltools`: any unnamed argument becomes
part of the element’s children, and a `mantine_element` passed as an
argument is itself serialized recursively (that’s how `Text("Hello")`
ends up nested inside
[`Card()`](https://coppertank.github.io/shiny.mantine/reference/Card.md)’s
`children` prop above).

[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)
is the one function that doesn’t return a plain `mantine_element` — it
calls `renderMantineRoot()`, which serializes the tree to JSON and wraps
it in a self-mounting `htmltools` fragment (a `<div>` holding the JSON
plus a `<script>` that calls
`window.jsmodule['@/shiny.mantine'].mount()`). This is why
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)
must always be the outermost call: it’s the one that actually produces
mountable HTML output.

## The generic reactive-props channel

Dedicated `update*()` functions like
[`updateMantineTextInput()`](https://coppertank.github.io/shiny.mantine/reference/TextInput.md)
only ever touch one thing: an input’s `value`. But plenty of props
aren’t a “value” in that sense — a `Modal`’s `opened`, a `Stepper`’s
`active`, a `Badge`’s `color`. For these, there’s a single generic
mechanism:
[`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md).

``` r

updateMantineProps
#> function (session = shiny::getDefaultReactiveDomain(), mantineId, 
#>     ...) 
#> {
#>     session$sendCustomMessage("shinyMantineUpdateProps", list(id = session$ns(mantineId), 
#>         props = list(...)))
#> }
#> <bytecode: 0x55769053f788>
#> <environment: namespace:shiny.mantine>
```

It sends `list(id = <mantineId>, props = list(...))` over a
`shinyMantineUpdateProps` custom message. On the JS side,
`withReactiveProps()` — a small HOC wrapping every component that
accepts a `mantineId` prop — keeps a local “patch” object in React state
per mounted `mantineId`, and merges any incoming props into it,
triggering a re-render:

``` js
function withReactiveProps(Component) {
  return function Wrapped({ mantineId, ...props }) {
    const [patch, setPatch] = useState({});
    useEffect(() => {
      if (!mantineId) return undefined;
      propUpdateHandlers[mantineId] = (newProps) => setPatch((prev) => ({ ...prev, ...newProps }));
      return () => { delete propUpdateHandlers[mantineId]; };
    }, [mantineId]);
    return React.createElement(Component, { ...props, ...patch });
  };
}
```

This is what makes `Modal(mantineId = "my_modal", ...)` +
`updateMantineProps(session, "my_modal", opened = TRUE)` work, and it’s
reused throughout the package: `Collapse`’s `opened`, `Stepper`’s
`active`, or any component’s `disabled`/`color`/`label` can all be
changed this way without rebuilding the tree.

``` r

# ui:
Modal(mantineId = "confirm", inputId = "confirm_state", title = "Confirm", Text("Are you sure?"))

# server:
observeEvent(input$open_btn, {
  updateMantineProps(session, "confirm", opened = TRUE)
})
```

Not every component supports `mantineId` — only ones explicitly wrapped
with `withReactiveProps()` in `js/src/index.js`, which in practice is
almost everything in the registry (including every component the
automated generator produces, see below).

## Reactive output: `mantineOutput()` / `renderMantine()`

[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)
mounts its whole tree once, statically, at page load. There is no
built-in way to make it reactively rebuild — unlike
[`uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html)/[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html)
for regular HTML.
[`mantineOutput()`](https://coppertank.github.io/shiny.mantine/reference/mantineOutput.md)/[`renderMantine()`](https://coppertank.github.io/shiny.mantine/reference/mantineOutput.md)
close this gap:

``` r

# ui:
mantineOutput("summary")

# server:
output$summary <- renderMantine({
  Card(withBorder = TRUE, Text(paste("Total:", sum(input$values))))
})
```

Each
[`mantineOutput()`](https://coppertank.github.io/shiny.mantine/reference/mantineOutput.md)
mounts its own independent React root via a generic Shiny output binding
registered in `js/src/index.js`. As with
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html), every
re-evaluation of the expression rebuilds the whole sub-tree, so
uncontrolled local state inside it (e.g. text typed into a `TextInput`
with no stable `inputId`) can be lost between updates.

If you want Mantine’s theme/color-scheme inside the reactive output too,
you can wrap the content in a nested
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)
— this is normally impossible to nest usefully (it would just serialize
as an inert HTML string, since its embedded mount `<script>` would never
execute once injected via `dangerouslySetInnerHTML`), but
`toMantineData()` special-cases it: `renderMantineRoot()` attaches the
pre-serialization element as an R attribute (`mantine_root`), and
`toMantineData()` checks for and recovers it before falling back to
generic HTML serialization:

``` r

# renderMantineRoot()/toMantineData() are internal (not exported), since
# ordinary usage never needs to call them directly.
nested <- shiny.mantine:::renderMantineRoot(Stack(Text("nested")))
recovered <- shiny.mantine:::toMantineData(nested)
str(recovered, max.level = 1)
#> List of 3
#>  $ type : chr "element"
#>  $ name : chr "Stack"
#>  $ props:List of 1
```

## The automated component generator

Most Mantine components need no special Shiny wiring at all — they’re
“pure display”: props and children in, rendered output out, with no
value to sync. Writing a hand-rolled adapter for each of these would be
pure repetition, so `js/scripts/generate-components.js` generates them
from a declarative manifest instead.

Each manifest entry looks like this:

``` js
{ name: 'Blockquote', slug: 'blockquote', doc: 'Styled quotation block' },
{
  name: 'List',
  slug: 'list',
  doc: 'Bulleted/numbered list',
  compound: [{ export: 'ListItem', jsName: 'Item' }],
},
```

Running the script regenerates two matched files:
`js/src/generated-components.js` (imports the named exports from
`@mantine/core` and registers them, each wrapped in
`withReactiveProps()`) and `R/generated-components.R` (an R
`displayComponent()` wrapper with a roxygen block, one per manifest
entry). To add a new “display only” component to the package:

    cd js
    # edit the MANIFEST array in scripts/generate-components.js
    node scripts/generate-components.js
    npm run build

``` r

devtools::document()
devtools::install()
```

Components that need real interaction — a stateful value, a click that
should report to Shiny, an anchored dropdown, a controller object like
`Tree`’s `useTree()` — are still written by hand (see `R/Inputs2.R`,
`R/Overlays.R`, `R/AdvancedComponents.R`, and the corresponding adapters
in `js/src/index.js`), since that’s exactly the part a declarative
manifest can’t express.
