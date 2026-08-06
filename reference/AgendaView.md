# Mantine AgendaView (`@mantine/schedule`): events as a vertical list

Displays events in a scrollable list grouped by date, in chronological
order, over a fixed `[rangeStart, rangeEnd]` window — no drag-and-drop,
no `date`/`onDateChange` navigation of its own (the app controls the
visible range directly). `input[[paste0(inputId, "_event_click")]]`
receives the clicked event's `id`.

## Usage

``` r
AgendaView(inputId, rangeStart, rangeEnd, events = list(), ...)
```

## Arguments

- inputId:

  Id used as the prefix for this view's Shiny inputs.

- rangeStart, rangeEnd:

  Start/end of the displayed date range (each a `"YYYY-MM-DD"` string,
  or an R `Date`/`POSIXct`).

- events:

  Events to display; see
  [`DayView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md)'s
  `events`.

- ...:

  Other props (`headerFormat`, `dateHeaderFormat`, `locale`, `labels`,
  ...). See <https://mantine.dev/schedule/agenda-view/>.

## Value

A `mantine_element` to nest inside
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md).

## Examples

``` r
if (FALSE) { # \dontrun{
AgendaView(
  inputId = "agenda1",
  rangeStart = Sys.Date(), rangeEnd = Sys.Date() + 7,
  events = data.frame(
    id = 1, title = "Team standup",
    start = "2026-07-27 09:00:00", end = "2026-07-27 09:30:00"
  )
)
} # }
```
