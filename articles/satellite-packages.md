# Satellite Packages

``` r

library(shiny)
library(shiny.mantine)
```

Beyond Mantine’s core component library (see the `core-*` vignettes,
starting with
[`vignette("core-layout")`](https://coppertank.github.io/shiny.mantine/articles/core-layout.md)),
`shiny.mantine` bundles every separate Mantine v9 npm package: dates,
notifications, modals, spotlight, charts, code-highlight, nprogress, a
rich text editor (tiptap), drag-and-drop file uploads (dropzone), and an
image/content carousel (carousel). This vignette walks through each with
a runnable example.

## `@mantine/dates`

Dates travel between R and JS as plain `"YYYY-MM-DD"` strings — Mantine
v9 itself represents dates this way (`DateStringValue = string`, not a
JS `Date` object), which makes them trivially JSON-serializable. Every
date input accepts either an R `Date`/`POSIXct` (converted automatically
via the internal `toDateString()` helper) or an already-formatted
string:

``` r

ui <- fluidPage(
  MantineProvider(
    Stack(
      DateInput("birth_date", label = "Date of birth", value = Sys.Date()),
      DatePickerInput("appointment", label = "Appointment"),
      TimeInput("meeting_time", label = "Meeting time"),
      DateTimePicker("event_at", label = "Event date & time")
    )
  )
)

server <- function(input, output, session) {
  observe(print(input$birth_date))  # a plain "YYYY-MM-DD" string
}

shinyApp(ui, server)
```

[`DatesProvider()`](https://coppertank.github.io/shiny.mantine/reference/DatesProvider.md)
sets locale/`firstDayOfWeek` for every date component nested inside it.
Also available:
[`MonthPickerInput()`](https://coppertank.github.io/shiny.mantine/reference/MonthPickerInput.md)/[`YearPickerInput()`](https://coppertank.github.io/shiny.mantine/reference/YearPickerInput.md)
(popover month/year-only selection) and their always-visible inline
counterparts
[`MonthPicker()`](https://coppertank.github.io/shiny.mantine/reference/MonthPicker.md)/[`YearPicker()`](https://coppertank.github.io/shiny.mantine/reference/YearPicker.md)
(like
[`DatePicker()`](https://coppertank.github.io/shiny.mantine/reference/DatePicker.md),
but for month/year granularity),
[`TimePicker()`](https://coppertank.github.io/shiny.mantine/reference/TimePicker.md)/[`TimeGrid()`](https://coppertank.github.io/shiny.mantine/reference/TimeGrid.md)
(dropdown/grid time pickers, distinct from the native
[`TimeInput()`](https://coppertank.github.io/shiny.mantine/reference/TimeInput.md)),
[`MiniCalendar()`](https://coppertank.github.io/shiny.mantine/reference/MiniCalendar.md)
(compact single-week strip),
[`InlineDateTimePicker()`](https://coppertank.github.io/shiny.mantine/reference/InlineDateTimePicker.md)
(like
[`DateTimePicker()`](https://coppertank.github.io/shiny.mantine/reference/DateTimePicker.md),
but always visible instead of behind a popover), and
[`TimeValue()`](https://coppertank.github.io/shiny.mantine/reference/TimeValue.md)
(a display-only component that formats a time string/`Date` for 12h/24h
display, e.g. inside a
[`Text()`](https://coppertank.github.io/shiny.mantine/reference/Text.md)).

## `@mantine/notifications`

[`Notifications()`](https://coppertank.github.io/shiny.mantine/reference/Notifications.md)
(Mantine-styled toasts) needs to be mounted **once** in the page —
typically as a sibling passed to
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)
alongside your main content — then driven imperatively from the server:

``` r

ui <- fluidPage(
  MantineProvider(
    Notifications(position = "top-right"),
    Button("Save", inputId = "save_btn")
  )
)

server <- function(input, output, session) {
  observeEvent(input$save_btn, {
    showMantineNotification(session, title = "Saved", message = "Your changes were saved.", color = "green")
  })
}

shinyApp(ui, server)
```

Use `hideMantineNotification(session, id)` to dismiss a specific
notification early (pass a matching `id = "..."` when showing it).

## `@mantine/modals`

[`ModalsProvider()`](https://coppertank.github.io/shiny.mantine/reference/ModalsProvider.md)
enables an imperative confirm/generic modal API, useful when you don’t
want to pre-declare a
[`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md)
in the UI:

``` r

ui <- fluidPage(
  MantineProvider(
    ModalsProvider(
      Button("Delete item", inputId = "delete_btn", color = "red")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$delete_btn, {
    openMantineConfirmModal(
      session, inputId = "confirm_delete",
      title = "Confirm deletion",
      children = "This action cannot be undone.",
      labels = list(confirm = "Delete", cancel = "Cancel"),
      confirmProps = list(color = "red")
    )
  })
  observeEvent(input$confirm_delete, {
    if (isTRUE(input$confirm_delete)) {
      # ... actually delete the item ...
    }
  })
}

shinyApp(ui, server)
```

**Important**: if you use both
[`Notifications()`](https://coppertank.github.io/shiny.mantine/reference/Notifications.md)/[`ModalsProvider()`](https://coppertank.github.io/shiny.mantine/reference/ModalsProvider.md)
and your own overlays,
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)
must always be the *outermost* call — never nest it inside
[`ModalsProvider()`](https://coppertank.github.io/shiny.mantine/reference/ModalsProvider.md).

## `@mantine/spotlight`

A command palette (opened with Ctrl/Cmd+K by default). Each action
reports its own `id` to `input[[inputId]]` when selected — the same
pattern as
[`menuItem()`](https://coppertank.github.io/shiny.mantine/reference/menuItem.md)/[`navLinkItem()`](https://coppertank.github.io/shiny.mantine/reference/navLinkItem.md):

``` r

ui <- fluidPage(
  MantineProvider(
    Spotlight(
      inputId = "spotlight_action",
      actions = list(
        list(id = "home", label = "Go to Home", description = "Main page"),
        list(id = "settings", label = "Go to Settings")
      )
    ),
    Text("Press Ctrl/Cmd+K to open the command palette")
  )
)

server <- function(input, output, session) {
  observeEvent(input$spotlight_action, {
    message("Navigating to: ", input$spotlight_action)
  })
}

shinyApp(ui, server)
```

For grouped actions (or a fully custom search/empty/footer layout) that
the flat `actions` list above doesn’t allow, use
[`SpotlightRoot()`](https://coppertank.github.io/shiny.mantine/reference/SpotlightRoot.md) +
[`SpotlightSearch()`](https://coppertank.github.io/shiny.mantine/reference/SpotlightRoot.md)/[`SpotlightActionsList()`](https://coppertank.github.io/shiny.mantine/reference/SpotlightRoot.md)/[`SpotlightActionsGroup()`](https://coppertank.github.io/shiny.mantine/reference/SpotlightRoot.md)/
[`SpotlightAction()`](https://coppertank.github.io/shiny.mantine/reference/SpotlightRoot.md)/[`SpotlightEmpty()`](https://coppertank.github.io/shiny.mantine/reference/SpotlightRoot.md)/[`SpotlightFooter()`](https://coppertank.github.io/shiny.mantine/reference/SpotlightRoot.md)
— the same global command-palette instance, no store management needed
from R. Unlike
[`Spotlight()`](https://coppertank.github.io/shiny.mantine/reference/Spotlight.md),
the compound form doesn’t filter actions by the search query itself:
[`SpotlightSearch()`](https://coppertank.github.io/shiny.mantine/reference/SpotlightRoot.md)
only renders the search box, matching typed text against actions (and
conditionally including
[`SpotlightEmpty()`](https://coppertank.github.io/shiny.mantine/reference/SpotlightRoot.md)
only when nothing matches) is up to you:

``` r

SpotlightRoot(
  SpotlightSearch(placeholder = "Search..."),
  SpotlightActionsList(
    SpotlightActionsGroup(
      label = "Navigation",
      SpotlightAction("spotlight_choice", "home", label = "Home"),
      SpotlightAction("spotlight_choice", "settings", label = "Settings")
    )
  )
)
```

## `@mantine/charts`

Chart components accept `data` as either a `data.frame` (one row per
point/category — converted automatically into a list of rows) or an
already-prepared list:

``` r

sales <- data.frame(month = c("Jan", "Feb", "Mar", "Apr"), revenue = c(120, 150, 90, 200))

ui <- fluidPage(
  MantineProvider(
    Stack(
      LineChart(
        data = sales, dataKey = "month",
        series = list(list(name = "revenue", color = "blue.6"))
      ),
      PieChart(data = data.frame(
        name = c("Desktop", "Mobile", "Tablet"),
        value = c(55, 35, 10),
        color = c("blue.6", "orange.6", "grape.6")
      ))
    )
  )
)

shinyApp(ui, function(input, output, session) {})
```

[`BarChart()`](https://coppertank.github.io/shiny.mantine/reference/LineChart.md)/[`AreaChart()`](https://coppertank.github.io/shiny.mantine/reference/LineChart.md)/[`RadarChart()`](https://coppertank.github.io/shiny.mantine/reference/RadarChart.md)/[`CompositeChart()`](https://coppertank.github.io/shiny.mantine/reference/RadarChart.md)
share
[`LineChart()`](https://coppertank.github.io/shiny.mantine/reference/LineChart.md)’s
`data`/`series` shape;
[`DonutChart()`](https://coppertank.github.io/shiny.mantine/reference/PieChart.md)/[`FunnelChart()`](https://coppertank.github.io/shiny.mantine/reference/FunnelChart.md)
share
[`PieChart()`](https://coppertank.github.io/shiny.mantine/reference/PieChart.md)’s
`name`/`value`/`color` shape.
[`RadialBarChart()`](https://coppertank.github.io/shiny.mantine/reference/RadialBarChart.md)/
[`BubbleChart()`](https://coppertank.github.io/shiny.mantine/reference/RadialBarChart.md)
take `data`/`dataKey` without `series`.
[`Sparkline()`](https://coppertank.github.io/shiny.mantine/reference/Sparkline.md)
takes a plain numeric vector instead of a `data.frame`.
[`BarsList()`](https://coppertank.github.io/shiny.mantine/reference/BarsList.md)
takes a `data.frame`/list of rows with `name`/`value` columns, rendering
each row as a horizontal bar with its value (no axes) — good for compact
top-N/leaderboard displays.
[`SunburstChart()`](https://coppertank.github.io/shiny.mantine/reference/SunburstChart.md)
(added in Mantine 9.5) takes a nested list like
[`Treemap()`](https://coppertank.github.io/shiny.mantine/reference/Treemap.md)
(`list(name=, value=, color=, children=...)`) and plots it as concentric
rings.
[`BulletChart()`](https://coppertank.github.io/shiny.mantine/reference/BulletChart.md)
(also added in 9.5) is a compact KPI chart: an actual `value` plotted
against an optional `target` and a `ranges` data.frame/list of rows
(`value` = each range’s upper bound, `color`, optional `label`) shown as
background bands.
[`ScatterChart()`](https://coppertank.github.io/shiny.mantine/reference/ScatterChart.md),
[`Treemap()`](https://coppertank.github.io/shiny.mantine/reference/Treemap.md),
[`Heatmap()`](https://coppertank.github.io/shiny.mantine/reference/Heatmap.md),
and
[`SankeyChart()`](https://coppertank.github.io/shiny.mantine/reference/SankeyChart.md)
have their own nested `data` shapes (documented in each function’s
[`?help`](https://rdrr.io/r/utils/help.html) page) rather than one flat
table, since their charts aren’t naturally one-row-per-point.

``` r

BulletChart(
  value = 260000, target = 275000, label = "Revenue",
  ranges = data.frame(
    value = c(150000, 225000, 300000),
    color = c("red.8", "yellow.8", "teal.8"),
    label = c("Poor", "Average", "Good")
  )
)
```

Charts with an unbounded container (e.g. a plain
[`Stack()`](https://coppertank.github.io/shiny.mantine/reference/Stack.md)
with no fixed height, as above) need an explicit `h` (height) —
Recharts, which every Mantine chart is built on, silently renders
nothing if it can’t resolve a definite pixel height for itself.
[`LineChart()`](https://coppertank.github.io/shiny.mantine/reference/LineChart.md)/[`BarChart()`](https://coppertank.github.io/shiny.mantine/reference/LineChart.md)/[`PieChart()`](https://coppertank.github.io/shiny.mantine/reference/PieChart.md)/
etc. happen to ship a sensible default; several of the newer chart types
([`RadarChart()`](https://coppertank.github.io/shiny.mantine/reference/RadarChart.md),
[`RadialBarChart()`](https://coppertank.github.io/shiny.mantine/reference/RadialBarChart.md),
[`BubbleChart()`](https://coppertank.github.io/shiny.mantine/reference/RadialBarChart.md),
[`CompositeChart()`](https://coppertank.github.io/shiny.mantine/reference/RadarChart.md),
[`ScatterChart()`](https://coppertank.github.io/shiny.mantine/reference/ScatterChart.md),
[`SunburstChart()`](https://coppertank.github.io/shiny.mantine/reference/SunburstChart.md))
do not, so pass `h = 250` (or similar) explicitly if one of these
renders blank.

Since Mantine 9.5,
[`LineChart()`](https://coppertank.github.io/shiny.mantine/reference/LineChart.md)/[`BarChart()`](https://coppertank.github.io/shiny.mantine/reference/LineChart.md)/[`AreaChart()`](https://coppertank.github.io/shiny.mantine/reference/LineChart.md)/
[`CompositeChart()`](https://coppertank.github.io/shiny.mantine/reference/RadarChart.md)/[`ScatterChart()`](https://coppertank.github.io/shiny.mantine/reference/ScatterChart.md)/[`BubbleChart()`](https://coppertank.github.io/shiny.mantine/reference/RadialBarChart.md)/[`PieChart()`](https://coppertank.github.io/shiny.mantine/reference/PieChart.md)/
[`DonutChart()`](https://coppertank.github.io/shiny.mantine/reference/PieChart.md)/[`RadarChart()`](https://coppertank.github.io/shiny.mantine/reference/RadarChart.md)/[`RadialBarChart()`](https://coppertank.github.io/shiny.mantine/reference/RadialBarChart.md)/[`FunnelChart()`](https://coppertank.github.io/shiny.mantine/reference/FunnelChart.md)
support `accessibilityLayer` (keyboard navigation, `TRUE` by default)
and
[`LineChart()`](https://coppertank.github.io/shiny.mantine/reference/LineChart.md)/[`BarChart()`](https://coppertank.github.io/shiny.mantine/reference/LineChart.md)/[`AreaChart()`](https://coppertank.github.io/shiny.mantine/reference/LineChart.md)/[`CompositeChart()`](https://coppertank.github.io/shiny.mantine/reference/RadarChart.md)
support `withBrush = TRUE` to show a range-selector brush under the
chart — both plain boolean props, passed through like any other.

## `@mantine/code-highlight`

[`CodeHighlight()`](https://coppertank.github.io/shiny.mantine/reference/CodeHighlight.md)/[`InlineCodeHighlight()`](https://coppertank.github.io/shiny.mantine/reference/CodeHighlight.md)
display code with a monospace font, line numbers, and a copy button, but
**without syntax coloring** — they always use Mantine’s
`plainTextAdapter` rather than pulling in `highlight.js`/`shiki`, to
keep the bundle from growing further.
`CodeHighlightTabs(code = list(list(fileName = ..., language = ..., code = ...), ...))`
displays several snippets as a tabbed file browser, same adapter. If you
need real syntax highlighting, you’d need to add such an adapter to
`js/src/index.js` yourself.

``` r

CodeHighlight(
  code = "server <- function(input, output, session) {\n  # ...\n}",
  language = "r"
)
```

## `@mantine/nprogress`

A slim progress bar pinned to the top of the page — the kind used for
page-navigation loading indicators. Mount
[`NavigationProgress()`](https://coppertank.github.io/shiny.mantine/reference/NavigationProgress.md)
once, then drive it imperatively:

``` r

ui <- fluidPage(
  MantineProvider(
    NavigationProgress(),
    Button("Run task", inputId = "go_btn")
  )
)

server <- function(input, output, session) {
  observeEvent(input$go_btn, {
    startMantineProgress(session)
    setMantineProgress(30, session)
    Sys.sleep(0.5)  # stand-in for real work
    setMantineProgress(70, session)
    Sys.sleep(0.5)
    completeMantineProgress(session)
  })
}

shinyApp(ui, server)
```

[`resetMantineProgress()`](https://coppertank.github.io/shiny.mantine/reference/NavigationProgress.md)/[`incrementMantineProgress()`](https://coppertank.github.io/shiny.mantine/reference/NavigationProgress.md)/[`decrementMantineProgress()`](https://coppertank.github.io/shiny.mantine/reference/NavigationProgress.md)
round out the imperative API.

## `@mantine/tiptap`

[`RichTextEditor()`](https://coppertank.github.io/shiny.mantine/reference/RichTextEditor.md)
is a rich text editor with **reduced scope** compared to a full Tiptap
setup: bold/italic/underline/strikethrough/highlight/ inline code, H1-H6
headings, blockquotes, lists (incl. task lists), links, alignment,
sub/superscript, and undo/redo — no tables, images, text color, or
collaborative editing.

``` r

ui <- fluidPage(
  MantineProvider(
    RichTextEditor("bio", content = "<p>Write something...</p>", placeholder = "Your bio"),
    Button("Reset", inputId = "reset_btn")
  ),
  verbatimTextOutput("html")
)

server <- function(input, output, session) {
  observeEvent(input$reset_btn, {
    updateMantineRichTextEditor(session, "bio", content = "<p></p>")
  })
  output$html <- renderPrint(input$bio)
}

shinyApp(ui, server)
```

`input[[inputId]]` receives the editor’s content as HTML on every edit —
treat it as untrusted user input if you ever render it back with
[`HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)/`dangerouslySetInnerHTML`-style
trust, the same way you would any other free-text field.

Use `controls` to trim down or reorder the toolbar (a list of character
vectors, one per visually separated button cluster):

``` r

RichTextEditor(
  "notes", content = "<p></p>",
  controls = list(c("bold", "italic"), c("bulletList", "orderedList"))
)
```

## `@mantine/dropzone`

[`Dropzone()`](https://coppertank.github.io/shiny.mantine/reference/Dropzone.md)
is a drag-and-drop (or click-to-browse) file upload area. Like
[`FileInput()`](https://coppertank.github.io/shiny.mantine/reference/FileInput.md)/[`FileButton()`](https://coppertank.github.io/shiny.mantine/reference/FileButton.md)
in
[`vignette("core-inputs")`](https://coppertank.github.io/shiny.mantine/articles/core-inputs.md)/
[`vignette("core-buttons")`](https://coppertank.github.io/shiny.mantine/articles/core-buttons.md),
only file *metadata* (name/size/type) is reported to Shiny, never the
file content — pair it with a real
[`shiny::fileInput()`](https://rdrr.io/pkg/shiny/man/fileInput.html)
alongside it if you need the actual upload.
[`DropzoneAccept()`](https://coppertank.github.io/shiny.mantine/reference/Dropzone.md)/[`DropzoneReject()`](https://coppertank.github.io/shiny.mantine/reference/Dropzone.md)/[`DropzoneIdle()`](https://coppertank.github.io/shiny.mantine/reference/Dropzone.md)
render different content depending on whether the dragged file(s)
currently over the dropzone would be accepted.

``` r

ui <- fluidPage(
  MantineProvider(
    Dropzone(
      inputId = "upload", accept = "image/png,image/jpeg", maxSize = 5 * 1024^2,
      DropzoneAccept(Text("Drop the file here")),
      DropzoneReject(Text("File type not accepted", c = "red")),
      DropzoneIdle(Text("Drag an image here, or click to select one"))
    )
  ),
  verbatimTextOutput("files")
)

server <- function(input, output, session) {
  output$files <- renderPrint(input$upload)
}

shinyApp(ui, server)
```

[`DropzoneFullScreen()`](https://coppertank.github.io/shiny.mantine/reference/Dropzone.md)
is the same idea, but instead of a fixed drop area it listens for drops
anywhere on the browser window while its `active` prop is `TRUE` —
typically toggled by a button via
`updateMantineProps(session, mantineId, active = TRUE/FALSE)`:

``` r

ui <- fluidPage(
  MantineProvider(
    Button("Activate full-screen drop", inputId = "activate_btn"),
    DropzoneFullScreen(
      inputId = "upload", mantineId = "full_dz", active = FALSE,
      Text("Drop files anywhere on the page")
    )
  )
)

server <- function(input, output, session) {
  active <- reactiveVal(FALSE)
  observeEvent(input$activate_btn, {
    active(!active())
    updateMantineProps(session, "full_dz", active = active())
  })
}

shinyApp(ui, server)
```

## `@mantine/carousel`

[`Carousel()`](https://coppertank.github.io/shiny.mantine/reference/Carousel.md)/[`CarouselSlide()`](https://coppertank.github.io/shiny.mantine/reference/Carousel.md)
— a swipeable/scrollable carousel for images or any other content, built
on Embla Carousel.

``` r

ui <- fluidPage(
  MantineProvider(
    Carousel(
      height = 200, slideSize = "33.333%", slideGap = "md", withIndicators = TRUE,
      CarouselSlide(Image(src = "https://placehold.co/400x200?text=1")),
      CarouselSlide(Image(src = "https://placehold.co/400x200?text=2")),
      CarouselSlide(Image(src = "https://placehold.co/400x200?text=3"))
    )
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)
```

## `@mantine/schedule`

Calendar/scheduling views:
[`DayView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md),
[`WeekView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md),
[`MonthView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md),
[`YearView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md),
[`AgendaView()`](https://coppertank.github.io/shiny.mantine/reference/AgendaView.md)
(a scrollable event list over a fixed date range),
[`MobileMonthView()`](https://coppertank.github.io/shiny.mantine/reference/MobileMonthView.md)
(touch-optimized), the resource-grouped
[`ResourcesDayView()`](https://coppertank.github.io/shiny.mantine/reference/ResourcesScheduleViews.md)/[`ResourcesWeekView()`](https://coppertank.github.io/shiny.mantine/reference/ResourcesScheduleViews.md)/[`ResourcesMonthView()`](https://coppertank.github.io/shiny.mantine/reference/ResourcesScheduleViews.md)
(events grouped into rows/columns by e.g. meeting room or staff member),
and
[`Schedule()`](https://coppertank.github.io/shiny.mantine/reference/Schedule.md)
(all of the above behind one component with its own day/week/month/year
switcher). Events are a `data.frame`/list of rows with `id`, `title`,
`start`, `end`, and optionally `color`/`resourceId` columns —
`start`/`end` accept `"YYYY-MM-DD HH:mm:ss"` strings or R
`Date`/`POSIXct` values, converted automatically.

``` r

events <- data.frame(
  id = 1:2,
  title = c("Team standup", "Client call"),
  start = c("2026-07-27 09:00:00", "2026-07-27 11:00:00"),
  end = c("2026-07-27 09:30:00", "2026-07-27 12:00:00"),
  color = c("blue", "green")
)

ui <- fluidPage(
  MantineProvider(
    DayView(inputId = "day1", date = Sys.Date(), events = events, startTime = "08:00:00")
  ),
  verbatimTextOutput("clicked")
)

server <- function(input, output, session) {
  output$clicked <- renderPrint(input$day1_event_click)
}

shinyApp(ui, server)
```

Every view reports its currently displayed `date` as `input[[inputId]]`
(the primary value, like every other stateful input in this package); a
handful of other interactions are reported under suffixed input ids —
`input[[paste0(inputId, "_event_click")]]` (clicked event’s `id`),
`input[[paste0(inputId, "_slot_click")]]`,
`input[[paste0(inputId, "_slot_select")]]` (a drag-to-select range,
needs `withDragSlotSelect = TRUE`),
`input[[paste0(inputId, "_event_drop")]]`/`input[[paste0(inputId, "_event_resize")]]`
(needs `withEventsDragAndDrop`/`withEventResize = TRUE`) — see
`?ScheduleViews` for the full list. Update `date`/`events` (or any other
prop) from the server with
[`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md)
(needs a `mantineId`).

[`ResourcesDayView()`](https://coppertank.github.io/shiny.mantine/reference/ResourcesScheduleViews.md)/[`ResourcesWeekView()`](https://coppertank.github.io/shiny.mantine/reference/ResourcesScheduleViews.md)/[`ResourcesMonthView()`](https://coppertank.github.io/shiny.mantine/reference/ResourcesScheduleViews.md)
also take a `resources` data.frame/list (`id`/`label` columns), and each
event’s `resourceId` should match one of them. Their `intervalMinutes`
prop (default `60`) accepts values dividing evenly into an hour (e.g.
`15`, `30`) *or* whole numbers of hours (e.g. `120`, `240`) — values
above `60` widen each column to span several hours instead of
subdividing within an hour, useful to fit a whole day in view compactly:

``` r

ResourcesDayView(
  inputId = "rooms1",
  date = Sys.Date(),
  resources = data.frame(id = c("tokyo", "paris"), label = c("Tokyo", "Paris")),
  events = data.frame(
    id = 1, title = "Team standup",
    start = "2026-07-27 09:00:00", end = "2026-07-27 10:00:00",
    resourceId = "tokyo"
  ),
  intervalMinutes = 240 # 4-hour-wide columns spanning midnight to midnight
)
```

Render-prop customization (`renderEvent`, `renderEventBody`,
`renderResourceLabel`, custom per-event drag/resize predicates, …) is
JS-callback-based and not exposed — every event is draggable/resizable
whenever the matching `with*` flag is set, and default rendering is used
throughout (the same trade-off already made for
[`Combobox()`](https://coppertank.github.io/shiny.mantine/reference/Combobox.md)/
[`TableOfContents()`](https://coppertank.github.io/shiny.mantine/reference/TableOfContents.md)/[`OverflowList()`](https://coppertank.github.io/shiny.mantine/reference/OverflowList.md);
see
[`vignette("core-misc")`](https://coppertank.github.io/shiny.mantine/articles/core-misc.md)).
