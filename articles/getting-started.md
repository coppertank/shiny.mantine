# Getting Started with shiny.mantine

``` r

library(shiny)
library(shiny.mantine)
```

## What is shiny.mantine?

`shiny.mantine` brings [Mantine UI v9](https://mantine.dev) — a modern
React component library covering inputs, layout, navigation, overlays,
charts, and more — into Shiny apps. Every component is a plain R
function that returns a `mantine_element`, composed the same way you’d
nest `htmltools` tags, and every stateful component keeps
`input[[inputId]]` in sync automatically.

This vignette covers installation and your first app. For the concepts
behind the package (how props are serialized, how updates flow from R
back to already-mounted components, the reactive output system), see
[`vignette("architecture", package = "shiny.mantine")`](https://coppertank.github.io/shiny.mantine/articles/architecture.md).
For the ten Mantine satellite packages (dates, notifications, modals,
spotlight, charts, code-highlight, nprogress, tiptap, dropzone,
carousel), see
[`vignette("satellite-packages", package = "shiny.mantine")`](https://coppertank.github.io/shiny.mantine/articles/satellite-packages.md).
For a tour of every `@mantine/core` component, organized the same way as
[mantine.dev/core](https://mantine.dev/core/), start with
[`vignette("core-layout", package = "shiny.mantine")`](https://coppertank.github.io/shiny.mantine/articles/core-layout.md).

## Installing the package

`shiny.mantine` ships with a *pre-built* JavaScript bundle
(`inst/www/mantine.js`), so installing the R package from a release is
enough to use it — no Node.js toolchain required at install time:

``` r

# from a local checkout or a released source tarball
devtools::install()
```

### Building the JS bundle from source

If you’re working from a development checkout where the bundle needs to
be (re)built — e.g. after pulling changes to `js/src/index.js`, or after
editing the component generator’s manifest — you’ll need Node.js and
npm:

    cd js
    npm install
    npm run build

This compiles `js/src/index.js` (the whole Mantine core library, React
19, and Tabler icons) into `inst/www/mantine.js`, plus one additional
chunk file per satellite package (`js/src/satellites/*.js` — dates,
notifications, modals, spotlight, charts, code-highlight, nprogress,
tiptap, dropzone, carousel), via webpack. The main bundle is
intentionally self-contained — see
[`vignette("architecture")`](https://coppertank.github.io/shiny.mantine/articles/architecture.md)
for why it bundles its own React copy instead of sharing one with
`shiny.react` — while each satellite chunk is only fetched the first
time a component from that family actually mounts, so an app that never
uses
e.g. [`RichTextEditor()`](https://coppertank.github.io/shiny.mantine/reference/RichTextEditor.md)
never downloads Tiptap at all.

After rebuilding the JS bundle, regenerate the R documentation and
reinstall:

``` r

devtools::document()
devtools::install()
```

## Your first app

Every `shiny.mantine` UI needs exactly one
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)
wrapping everything — it supplies the theme and color-scheme context
that every other component depends on:

``` r

library(shiny)
library(shiny.mantine)

ui <- fluidPage(
  MantineProvider(
    Stack(
      Title("Hello, Mantine"),
      TextInput(inputId = "name", label = "Your name", placeholder = "Ada Lovelace"),
      Button("Greet me", inputId = "greet_btn"),
      Text(textOutput("greeting"))
    )
  )
)

server <- function(input, output, session) {
  output$greeting <- renderText({
    req(input$greet_btn > 0)
    paste("Hello,", input$name %||% "stranger", "!")
  })
}

shinyApp(ui, server)
```

A few things to notice:

- **`TextInput(inputId = "name", ...)`** behaves exactly like
  [`shiny::textInput()`](https://rdrr.io/pkg/shiny/man/textInput.html):
  `input$name` updates on every keystroke.
- **`Button(..., inputId = "greet_btn")`** behaves like
  [`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html):
  `input$greet_btn` is a click counter.
- Mixing a native Shiny output
  ([`textOutput()`](https://rdrr.io/pkg/shiny/man/textOutput.html))
  *inside* a `shiny.mantine` component
  ([`Text()`](https://coppertank.github.io/shiny.mantine/reference/Text.md))
  works fine — it’s the reverse (nesting a native Shiny binding as a
  **direct structural child of**
  [`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)’s
  own markup) that doesn’t, since that content is injected via
  `dangerouslySetInnerHTML` and Shiny won’t re-scan it for bindings.
  Keep native Shiny inputs/outputs either fully outside
  [`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md),
  or nested inside a `shiny.mantine` component like
  [`Text()`](https://coppertank.github.io/shiny.mantine/reference/Text.md)/[`Card()`](https://coppertank.github.io/shiny.mantine/reference/Card.md)
  (as shown above), not as siblings passed directly to
  [`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)’s
  own `...`.

Everything should render at its normal, intended size out of the box,
regardless of whether your UI uses
[`fluidPage()`](https://rdrr.io/pkg/shiny/man/fluidPage.html) (which
loads Shiny’s bundled Bootstrap 3 CSS, setting the page’s root font-size
to 10px instead of the browser’s 16px default) or a plain
[`tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html)
(which doesn’t).
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)
measures the real root font-size at mount time and compensates
automatically either way — see “Font-size scaling under Shiny’s
Bootstrap CSS” in the README — but it’s worth knowing about if you ever
pass your own `theme` with an explicit `scale`, or set
`fixShinyFontScale = FALSE`.

## A fuller example: AppShell with page navigation

The package ships a demo with a complete responsive layout — header,
collapsible navbar, contextual aside, footer — and a client-side page
router so navigating between “pages” needs no server round-trip:

``` r

shiny::runApp(system.file("examples/appshell-app.R", package = "shiny.mantine"))
```

Every [ui.mantine.dev](https://ui.mantine.dev/) category also has its
own runnable demo in `inst/examples/` — see the README’s “Examples per
category” table, or list them with:

``` r

list.files(system.file("examples", package = "shiny.mantine"))
```

## Where to go next

- [`vignette("architecture")`](https://coppertank.github.io/shiny.mantine/articles/architecture.md)
  — how the R-to-React serialization works, the generic
  [`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md)
  channel, and
  [`mantineOutput()`](https://coppertank.github.io/shiny.mantine/reference/mantineOutput.md)/[`renderMantine()`](https://coppertank.github.io/shiny.mantine/reference/mantineOutput.md).
- [`vignette("core-layout")`](https://coppertank.github.io/shiny.mantine/articles/core-layout.md)
  — the first of ten `core-*` vignettes touring every `@mantine/core`
  component, one per mantine.dev/core category.
- [`vignette("satellite-packages")`](https://coppertank.github.io/shiny.mantine/articles/satellite-packages.md)
  — dates, notifications, modals, spotlight, charts, code-highlight,
  nprogress, the rich text editor, dropzone, and carousel.
- [`vignette("extras")`](https://coppertank.github.io/shiny.mantine/articles/extras.md)
  — group inputs, drag-and-drop reordering, and button recipes that
  don’t have their own mantine.dev/core page.
