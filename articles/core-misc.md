# Core: Miscellaneous

``` r

library(shiny)
library(shiny.mantine)
```

An R rewrite of the [“Miscellaneous”
category](https://mantine.dev/core/box/) on mantine.dev/core —
components that don’t fit neatly into the other nine categories — plus,
at the end, the two core-level provider components and a summary of
what’s intentionally not wrapped anywhere in `shiny.mantine`.

## Box

<https://mantine.dev/core/box/> — the most basic building block: a
`<div>` (or any element via `component`) with access to every Mantine
style prop (`p`, `m`, `bg`, `c`, …). Most components in this package are
themselves built on top of it.

``` r

Box(p = "md", bg = "gray.1", style = list(borderRadius = 8), Text("A styled box"))
```

## Collapse

<https://mantine.dev/core/collapse/> — animated show/hide for its
children; `opened` is controlled entirely from R via `mantineId` +
[`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md)
(there’s no click target built in — pair it with a
[`Button()`](https://coppertank.github.io/shiny.mantine/reference/Button.md)).

``` r

Stack(
  Button("Toggle details", inputId = "toggle_btn"),
  Collapse(mantineId = "details", opened = FALSE, Text("Collapsible content revealed here."))
)

# server:
observeEvent(input$toggle_btn, {
  updateMantineProps(session, "details", opened = input$toggle_btn %% 2 == 1)
})
```

## Divider

<https://mantine.dev/core/divider/> — a horizontal (or vertical) rule,
optionally with a centered `label`.

``` r

Stack(Text("Section one"), Divider(label = "OR", labelPosition = "center"), Text("Section two"))
```

## Marquee

<https://mantine.dev/core/marquee/> — a horizontally scrolling ticker of
content, for announcements/logos.

``` r

Marquee(Text("Breaking news: shiny.mantine now covers every Mantine core component!"))
```

## Paper

<https://mantine.dev/core/paper/> — a bordered/shadowed surface, the
plain content container
[`Card()`](https://coppertank.github.io/shiny.mantine/reference/Card.md)
builds on; used throughout this package’s own examples as the default
“box around a demo”.

``` r

Paper(withBorder = TRUE, shadow = "sm", radius = "md", p = "lg", Text("Content inside a Paper"))
```

## Portal

<https://mantine.dev/core/portal/> — renders its children into a
different part of the DOM (`document.body` by default), the mechanism
[`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md)/[`Menu()`](https://coppertank.github.io/shiny.mantine/reference/Menu.md)/[`Tooltip()`](https://coppertank.github.io/shiny.mantine/reference/Tooltip.md)
use internally to escape any parent’s `overflow: hidden`/`z-index`
stacking context. Rarely needed directly.

``` r

Portal(Text("Rendered at the end of <body>, not in its original position in the tree."))
```

## ScrollArea

<https://mantine.dev/core/scroll-area/> — a styled scrollable container
with custom (not browser-native) scrollbars.
[`ScrollAreaAutosize()`](https://coppertank.github.io/shiny.mantine/reference/ScrollAreaAutosize.md)
grows with content up to `mah` before scrolling;
[`NativeScrollArea()`](https://coppertank.github.io/shiny.mantine/reference/ScrollAreaAutosize.md)
opts back into plain OS scrollbars while keeping the same API.

``` r

ScrollArea(h = 200, Stack(lapply(1:30, function(i) Text(paste("Line", i)))))
```

## Scroller

<https://mantine.dev/core/scroller/> — a horizontally-scrollable
container with prev/next arrow controls, e.g. for a row of chips or
thumbnails that doesn’t fit the available width.

``` r

Scroller(
  Group(gap = "xs", wrap = "nowrap", lapply(1:20, function(i) Badge(paste("Item", i))))
)
```

## OverflowList

<https://mantine.dev/core/overflow-list/> — hides items that don’t fit
in the container width and collapses them into a single indicator. Real
Mantine configures this via `renderItem`/`renderOverflow` (JS render
functions); here, pass fully pre-built elements directly and the hidden
count is folded into `overflowLabel` (`"{n}"` is substituted):

``` r

OverflowList(
  Badge("Apple"), Badge("Banana"), Badge("Cherry"), Badge("Date"), Badge("Elderberry"),
  overflowLabel = "+{n} more"
)
```

## TableOfContents

<https://mantine.dev/core/table-of-contents/> — scans the page’s real
DOM headings and highlights whichever is in view as the user scrolls;
clicking an entry scrolls it into view. This is Mantine’s own documented
recipe hardcoded in (the only part that’s a JS callback, so the only
part that can’t be customized from R) — `scrollSpySelector` is the one
thing every real usage actually varies:

``` r

TableOfContents(scrollSpySelector = "#article h2, #article h3")
```

## Transition

<https://mantine.dev/core/transition/> — mounts/unmounts a child with an
animation (fade, slide, scale, …), controlled by `mounted`.

``` r

Stack(
  Button("Toggle", inputId = "transition_btn"),
  Transition(mantineId = "fade_box", mounted = TRUE, transition = "fade", Paper(withBorder = TRUE, p = "md", Text("Fades in/out")))
)

# server:
observeEvent(input$transition_btn, {
  updateMantineProps(session, "fade_box", mounted = input$transition_btn %% 2 == 1)
})
```

## VisuallyHidden

<https://mantine.dev/core/visually-hidden/> — visually hides content
while keeping it available to screen readers (e.g. a label for an
icon-only button that also needs visible sighted-user context
elsewhere).

``` r

ActionIcon(inputId = "search_icon_btn", IconSearch(size = 18), VisuallyHidden("Search"))
```

## FocusTrap / RemoveScroll

Not on mantine.dev/core’s own “Miscellaneous” page, but closely related
in spirit — the focus-trapping/scroll-locking mechanisms
[`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md)/
[`Drawer()`](https://coppertank.github.io/shiny.mantine/reference/Drawer.md)
use internally (see
[`vignette("core-overlays")`](https://coppertank.github.io/shiny.mantine/articles/core-overlays.md)),
exposed for building other fully custom overlays:

``` r

FocusTrap(
  active = TRUE,
  Stack(
    FocusTrapInitialFocus(), # marks which element should receive focus first
    TextInput(inputId = "first_field", label = "Focused first"),
    TextInput(inputId = "second_field", label = "Second field")
  )
)
RemoveScroll(enabled = TRUE, Paper(withBorder = TRUE, p = "md", Text("Page behind this can't be scrolled while enabled.")))
```

## Provider components

[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)
— required, always outermost, see
[`vignette("getting-started")`](https://coppertank.github.io/shiny.mantine/articles/getting-started.md)
— aside, the two other core-level providers:

[`DirectionProvider()`](https://coppertank.github.io/shiny.mantine/reference/DirectionProvider.md)
sets `"ltr"`/`"rtl"` reading direction for everything nested inside:

``` r

MantineProvider(DirectionProvider(dir = "rtl"), Text("Right-to-left content"))
```

`MantineThemeProvider(theme = list(...))` updates the theme *object*
exposed via Mantine’s `useMantineTheme()` hook for custom code that
explicitly reads it. **It does not restyle standard components**
([`Button()`](https://coppertank.github.io/shiny.mantine/reference/Button.md),
[`Badge()`](https://coppertank.github.io/shiny.mantine/reference/Badge.md),
…): those get their colors from CSS variables that only the outermost
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)
injects once, so nesting a
[`MantineThemeProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineThemeProvider.md)
with a different `primaryColor` will *not* change a nested
[`Button()`](https://coppertank.github.io/shiny.mantine/reference/Button.md)’s
color:

``` r

Group(
  Button("Outside the provider", inputId = "btn_a"),
  MantineThemeProvider(theme = list(primaryColor = "red"), Button("Inside (still the same color)", inputId = "btn_b"))
)
```

If you need a visually different theme for part of a page, that
currently requires a second, independent
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)
(with its own color-scheme-sync caveat — see the README’s “Known
limitations”).

## Intentionally out of scope

A handful of `@mantine/core`/`@mantine/dates` exports have no R wrapper,
each for a concrete architectural reason rather than “not gotten to yet”
(every `mantine.dev` page was checked against this package’s exports —
see
[`vignette("core-combobox")`](https://coppertank.github.io/shiny.mantine/articles/core-combobox.md)
for how far the pragmatic
[`Combobox()`](https://coppertank.github.io/shiny.mantine/reference/Combobox.md)
wrapper actually goes, which is further than the bullets below):

- **`FloatingIndicator`** (and the lower-level `FloatingArrow`) — both
  need a literal DOM element `ref` (`target`/`parent`) recalculated on
  every state change, not a plain, JSON-serializable R value. Mantine’s
  own styled components
  ([`SegmentedControl()`](https://coppertank.github.io/shiny.mantine/reference/SegmentedControl.md),
  [`Tabs()`](https://coppertank.github.io/shiny.mantine/reference/Tabs.md),
  …) already provide the equivalent animated-indicator effect out of the
  box without it.
- **SSR/Next.js-specific helpers** (`ColorSchemeScript`,
  `HeadlessMantineProvider`, `InlineStyles`) — not applicable to Shiny’s
  client-side-only mount architecture.
- **`Calendar`** (`@mantine/dates`) and its sub-parts (`Month`, `Day`,
  `WeekdaysRow`, …) — the low-level primitive
  [`DatePicker()`](https://coppertank.github.io/shiny.mantine/reference/DatePicker.md)/
  [`DatePickerInput()`](https://coppertank.github.io/shiny.mantine/reference/DatePickerInput.md)/[`MonthPicker()`](https://coppertank.github.io/shiny.mantine/reference/MonthPicker.md)/[`YearPicker()`](https://coppertank.github.io/shiny.mantine/reference/YearPicker.md)
  are built on; customization beyond what those offer goes through a
  function-based `getDayProps` callback, which can’t cross the R/JSON
  bridge.
- **`RichTextEditor`’s `ColorPicker`/`Color`/`UnsetColor` controls** —
  would need the Tiptap `Color`/`TextStyle` extensions plus a swatches
  configuration wired in; out of scope for this package’s intentionally
  reduced-scope editor (see
  [`vignette("core-typography")`](https://coppertank.github.io/shiny.mantine/articles/core-typography.md)
  — no tables, images, or collaborative editing either).

## Where to go next

- [`vignette("core-layout")`](https://coppertank.github.io/shiny.mantine/articles/core-layout.md)
  — where the tour of mantine.dev/core starts.
- [`vignette("satellite-packages")`](https://coppertank.github.io/shiny.mantine/articles/satellite-packages.md)
  — the separate npm packages (`@mantine/dates`, `notifications`,
  `modals`, `spotlight`, `charts`, `code-highlight`, `nprogress`,
  `tiptap`, `dropzone`, `carousel`).
- [`vignette("architecture")`](https://coppertank.github.io/shiny.mantine/articles/architecture.md)
  — how every component here is serialized and kept in sync with Shiny
  under the hood.
