# shiny.mantine

<!-- badges: start -->
[![R-CMD-check](https://github.com/coppertank/shiny.mantine/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/coppertank/shiny.mantine/actions/workflows/R-CMD-check.yaml)
[![pkgdown](https://github.com/coppertank/shiny.mantine/actions/workflows/pkgdown.yaml/badge.svg)](https://coppertank.github.io/shiny.mantine/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE.md)
<!-- badges: end -->

R wrappers for [Mantine UI v9](https://mantine.dev) — a modern React
component library — for use in [Shiny](https://shiny.posit.co/) apps.

Every component in Mantine's core library and all eight of its satellite
packages (dates, notifications, modals, spotlight, charts, code
highlighting, progress bar, rich text editor) are wrapped, plus a
client-side page router and two architectural pieces regular one-way
`htmltools` rendering doesn't give you: a generic reactive-props update
channel and a `renderUI()`-equivalent reactive output for Mantine content.

```r
library(shiny)
library(shiny.mantine)

ui <- fluidPage(
  MantineProvider(
    TextInput(inputId = "name", label = "Your name"),
    Button("Greet", inputId = "greet_btn", variant = "filled")
  ),
  textOutput("greeting")
)

server <- function(input, output, session) {
  output$greeting <- renderText({
    req(input$greet_btn)
    paste("Hello,", input$name)
  })
}

shinyApp(ui, server)
```

## Features

- **Full core coverage** — layout, typography, navigation, every stateful
  input, overlays, data display, and dozens of smaller components.
- **All 8 satellite packages** — `@mantine/dates`, `notifications`,
  `modals`, `spotlight`, `charts` (13 chart types), `code-highlight`,
  `nprogress`, and `tiptap` (rich text editor).
- **`Pages()`/`Page()`** — a client-side router for multi-page apps with
  instant, no-round-trip navigation.
- **`updateMantineProps()`** — a generic channel to update *any* prop of a
  mounted component from the server, not just an input's value.
- **`mantineOutput()`/`renderMantine()`** — a reactive output for Mantine
  content, the `uiOutput()`/`renderUI()` equivalent.
- **Extras beyond plain Mantine**: drag & drop reordering, a
  search/sort/select data table, and a demo app for every
  [ui.mantine.dev](https://ui.mantine.dev/) category.

## Installation

The JS bundle needs to be built once before installing:

```sh
cd js && npm install && npm run build
```

```r
devtools::document()
devtools::install()
```

## Documentation

Long-form guides ship as package vignettes
(`browseVignettes("shiny.mantine")`):

| Vignette | Covers |
|---|---|
| `getting-started` | Installing the package and building your first app |
| `architecture` | The serialization engine, reactive props, reactive output, the automated component generator |
| `satellite-packages` | A worked example for each of the 8 satellite packages |
| `component-gallery` | A categorized tour of every component, plus what's intentionally out of scope and why |

`inst/examples/` has a runnable demo app per
[ui.mantine.dev](https://ui.mantine.dev/) category (buttons, navbars,
headers, tables, dropzones, carousels, ...), a full `AppShell` app with
page navigation, and a real-world 3-page financial dashboard (KPI cards,
13 chart types, data tables) modeled on a public Plotly Dash example:

```r
shiny::runApp(system.file("examples/appshell-app.R", package = "shiny.mantine"))
shiny::runApp(system.file("examples/financial-dashboard-app.R", package = "shiny.mantine"))
```

## Why a bundled React runtime?

Mantine v9 requires React ≥ 19, which conflicts with
[shiny.react](https://github.com/Appsilon/shiny.react)'s shared React 18
runtime — mixing two React copies in one tree causes hook-level crashes.
`shiny.mantine` is inspired by `shiny.react`'s conventions (props as JSON,
custom-message updates, `htmlDependency`) but bundles its own independent
React 19 copy and JS runtime instead of reusing `shiny.react`'s. See
`vignette("architecture")` for the full story.

## Tests

```r
devtools::test()        # R: testthat
```
```sh
cd js && npm test        # JS: Jest
```

Both suites cover serialization logic and the R/JS contract; every
component is additionally verified in a real browser (Playwright) during
development.

## Known limitations

- Don't nest `shiny::textOutput()`/other native Shiny bindings directly
  inside `MantineProvider()` — see `vignette("getting-started")`.
- Multiple `MantineProvider()`s on one page don't sync color scheme live
  between each other (persists via `localStorage`, so it's consistent
  after a reload).
- The JS bundle is ~2.3 MiB (React 19 + Mantine core, all 8 satellite
  packages, Recharts, Tiptap, Tabler icons). Fine for internal/demo use;
  consider code-splitting per route for production.
- `CodeHighlight()` has no real syntax coloring (plain-text adapter only,
  to avoid bundling `highlight.js`/`shiki`); `RichTextEditor()` covers
  basic formatting only (no tables, images, or collaborative editing).
- Stacked modals/drawers (multiple overlays open at once) aren't
  supported. See `vignette("component-gallery")`'s "Intentionally out of
  scope" section for this and other low-level primitives left unwrapped.

## License

MIT
