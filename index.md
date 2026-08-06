# shiny.mantine

R wrappers for [Mantine UI v9](https://mantine.dev) — a modern React
component library — for use in [Shiny](https://shiny.posit.co/) apps.

Every component in Mantine’s core library and all 11 of its satellite
packages (dates, notifications, modals, spotlight, charts, code
highlighting, navigation progress bar, rich text editor, dropzone,
carousel, schedule) are wrapped, plus a client-side page router and two
architectural pieces regular one-way `htmltools` rendering doesn’t give
you: a generic reactive-props update channel and a
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html)-equivalent
reactive output for Mantine content.

``` r

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

- **Full core coverage** — layout, typography, navigation, every
  stateful input, overlays, data display, and dozens of smaller
  components.
- **All 11 satellite packages** — `@mantine/dates`, `notifications`,
  `modals`, `spotlight`, `charts` (18 chart types), `code-highlight`,
  `nprogress`, `tiptap` (rich text editor), `dropzone`, `carousel`, and
  `schedule` (calendar/scheduling views).
- **[`Pages()`](https://coppertank.github.io/shiny.mantine/reference/Pages.md)/[`Page()`](https://coppertank.github.io/shiny.mantine/reference/Pages.md)**
  — a client-side router for multi-page apps with instant, no-round-trip
  navigation.
- **[`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md)**
  — a generic channel to update *any* prop of a mounted component from
  the server, not just an input’s value.
- **[`mantineOutput()`](https://coppertank.github.io/shiny.mantine/reference/mantineOutput.md)/[`renderMantine()`](https://coppertank.github.io/shiny.mantine/reference/mantineOutput.md)**
  — a reactive output for Mantine content, the
  [`uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html)/[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html)
  equivalent.
- **[`ModalStack()`](https://coppertank.github.io/shiny.mantine/reference/ModalStack.md)/[`DrawerStack()`](https://coppertank.github.io/shiny.mantine/reference/DrawerStack.md)**
  — coordinated stacks of
  [`Modal()`](https://mantine.dev/core/modal/#stacked-modals)/[`Drawer()`](https://mantine.dev/core/drawer/#stacked-drawers)s
  (layered z-index, focus trapping, `closeAll()`), opened/closed with
  the same
  [`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md)
  calls as a standalone one.
- **Extras beyond plain Mantine**: drag & drop reordering, a
  search/sort/select data table, and a demo app for every
  [ui.mantine.dev](https://ui.mantine.dev/) category.

## Installation

The JS bundle needs to be built once before installing:

``` sh
cd js && npm install && npm run build
```

``` r

devtools::document()
devtools::install()
```

## Documentation

Long-form guides ship as package vignettes
(`browseVignettes("shiny.mantine")`):

| Vignette | Covers |
|----|----|
| `getting-started` | Installing the package and building your first app |
| `architecture` | The serialization engine, reactive props, reactive output, the automated component generator |
| `core-layout` | AppShell, AspectRatio, Center, Container, Flex, Grid, Group, SimpleGrid, Space, Splitter, Stack |
| `core-inputs` | Text/numeric/choice/boolean form inputs, sliders, color pickers, the Input family |
| `core-combobox` | Select, MultiSelect, TagsInput, Autocomplete, TreeSelect, Cascader, Pill, ComboboxPopover, Combobox |
| `core-buttons` | Button, ActionIcon, CloseButton, CopyButton, FileButton, UnstyledButton |
| `core-navigation` | Anchor, Breadcrumbs, Burger, NavLink, Pagination, Stepper, Tabs, Tree |
| `core-feedback` | Alert, Loader, Progress, RingProgress, Skeleton, Notification, EmptyState |
| `core-overlays` | Modal, Drawer, Dialog, Popover, HoverCard, Tooltip, Menu, Menubar, Affix |
| `core-data-display` | Accordion, Avatar, Badge, Card, Image, Table/DataTable, Timeline |
| `core-typography` | Text, Title, Blockquote, Code, Highlight, List, Mark, Typography |
| `core-misc` | Box, Collapse, Divider, Paper, Portal, ScrollArea, OverflowList, TableOfContents, Transition, provider components |
| `satellite-packages` | A worked example for each of the 11 satellite packages |
| `extras` | Group inputs, drag-and-drop reordering, and pure-R button recipes |

`inst/examples/` has a runnable demo app per
[ui.mantine.dev](https://ui.mantine.dev/) category (buttons, navbars,
headers, tables, dropzones, carousels, …), a full `AppShell` app with
page navigation, and a real-world 3-page financial dashboard (KPI cards,
13 chart types, data tables) modeled on a public Plotly Dash example:

``` r

shiny::runApp(system.file("examples/appshell-app.R", package = "shiny.mantine"))
shiny::runApp(system.file("examples/financial-dashboard-app.R", package = "shiny.mantine"))
```

## Why a bundled React runtime?

Mantine v9 requires React ≥ 19, which conflicts with
[shiny.react](https://github.com/Appsilon/shiny.react)’s shared React 18
runtime — mixing two React copies in one tree causes hook-level crashes.
`shiny.mantine` is inspired by `shiny.react`’s conventions (props as
JSON, custom-message updates, `htmlDependency`) but bundles its own
independent React 19 copy and JS runtime instead of reusing
`shiny.react`’s. See
[`vignette("architecture")`](https://coppertank.github.io/shiny.mantine/articles/architecture.md)
for the full story.

## Tests

``` r

devtools::test()        # R: testthat
```

``` sh
cd js && npm test        # JS: Jest
```

Both suites cover serialization logic and the R/JS contract; every
component is additionally verified in a real browser (Playwright) during
development.

## Known limitations

- Don’t nest
  [`shiny::textOutput()`](https://rdrr.io/pkg/shiny/man/textOutput.html)/other
  native Shiny bindings directly inside
  [`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)
  — see
  [`vignette("getting-started")`](https://coppertank.github.io/shiny.mantine/articles/getting-started.md).
- Multiple
  [`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)s
  on one page don’t sync color scheme live between each other (persists
  via `localStorage`, so it’s consistent after a reload).
- The main JS bundle (`inst/www/mantine.js`, always loaded) is ~1.1 MiB
  — React 19, every `@mantine/core` component, Tabler icons. Each of the
  11 satellite packages (dates, notifications, modals, spotlight,
  charts, code-highlight, nprogress, tiptap, dropzone, carousel,
  schedule) ships as its own chunk (e.g. `charts.mantine.js`,
  `tiptap.mantine.js`, `schedule.mantine.js`), fetched on demand the
  first time a component from that family actually mounts — an app that
  never uses e.g.
  [`LineChart()`](https://coppertank.github.io/shiny.mantine/reference/LineChart.md)/[`RichTextEditor()`](https://coppertank.github.io/shiny.mantine/reference/RichTextEditor.md)/[`DayView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md)
  never downloads Recharts/Tiptap/`@mantine/schedule` at all.
- [`CodeHighlight()`](https://coppertank.github.io/shiny.mantine/reference/CodeHighlight.md)
  has no real syntax coloring (plain-text adapter only, to avoid
  bundling `highlight.js`/`shiki`);
  [`RichTextEditor()`](https://coppertank.github.io/shiny.mantine/reference/RichTextEditor.md)
  covers basic formatting only (no tables, images, or collaborative
  editing).
- `@mantine/schedule` views
  ([`DayView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md)
  and family) don’t expose per-event drag/resize permission callbacks or
  custom event/header rendering (`canDragEvent`, `renderEvent`,
  `renderEventBody`, …) — JS functions that can’t cross the R/JSON
  bridge; every event is draggable/resizable whenever the matching
  `with*` flag is set, and default rendering is used throughout.
- See
  [`vignette("core-misc")`](https://coppertank.github.io/shiny.mantine/articles/core-misc.md)’s
  “Intentionally out of scope” section for the low-level primitives left
  unwrapped.

## License

MIT
