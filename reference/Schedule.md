# Mantine Schedule (`@mantine/schedule`): unified view with built-in switching

Combines
[`DayView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md)/[`WeekView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md)/[`MonthView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md)/[`YearView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md)
behind one component with its own header controls for switching between
them. `input[[inputId]]` holds the displayed `date`;
`input[[paste0(inputId, "_view")]]` holds the active view level (e.g.
`"day"`/`"week"`/`"month"`/`"year"`). Other interactions are reported
the same way as
[`DayView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md)
(see `?ScheduleViews`).

## Usage

``` r
Schedule(inputId, date = NULL, view = NULL, events = list(), ...)
```

## Arguments

- inputId:

  Id of the Shiny input holding the displayed `date`.

- date:

  Initial displayed date (a `"YYYY-MM-DD"` string, or an R
  `Date`/`POSIXct`).

- view:

  Initial view level (e.g. `"day"`, `"week"`, `"month"`, `"year"`).

- events:

  Events to display; see
  [`DayView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md)'s
  `events`.

- ...:

  Other props (`dayViewProps`, `weekViewProps`, `monthViewProps`,
  `yearViewProps` — each a named list forwarded to the matching view —
  `withAgenda`, `withEventsDragAndDrop`, `withEventResize`, ...). See
  <https://mantine.dev/schedule/schedule/>.

## Value

A `mantine_element` to nest inside
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md).

## Examples

``` r
if (FALSE) { # \dontrun{
Schedule(
  inputId = "sched1", view = "week",
  events = data.frame(
    id = 1, title = "Team standup",
    start = "2026-07-27 09:00:00", end = "2026-07-27 09:30:00"
  )
)
} # }
```
