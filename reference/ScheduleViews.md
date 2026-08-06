# Mantine schedule views (`@mantine/schedule`): Day/Week/Month/Year

Calendar views for a single resource (see
[`ResourcesDayView()`](https://coppertank.github.io/shiny.mantine/reference/ResourcesScheduleViews.md)
and family for the resource-grouped equivalents). Fully controlled:
`input[[inputId]]` holds the currently displayed `date` (a
`"YYYY-MM-DD"` string), synced whenever the user navigates. Several
other interactions are additionally reported under suffixed input ids:

- `input[[paste0(inputId, "_event_click")]]` — clicked event's `id`.

- `input[[paste0(inputId, "_slot_click")]]` — clicked time slot (shape
  depends on the view — usually a datetime string).

- `input[[paste0(inputId, "_all_day_click")]]` — clicked all-day slot's
  date (`DayView()`/`WeekView()`).

- `input[[paste0(inputId, "_slot_select")]]` —
  `list(rangeStart=, rangeEnd=)` after a drag-to-select (needs
  `withDragSlotSelect = TRUE`), for creating a new event server-side.

- `input[[paste0(inputId, "_event_drop")]]` —
  `list(eventId=, newStart=, newEnd=)` after a drag-and-drop (needs
  `withEventsDragAndDrop = TRUE`); the view's own display already moves
  the event immediately (no server round-trip needed for the visual
  feedback), so this is meant for persisting the change server-side.

- `input[[paste0(inputId, "_event_resize")]]` — same shape, after a
  resize (needs `withEventResize = TRUE`).

## Usage

``` r
DayView(inputId, date = NULL, events = list(), ...)

WeekView(inputId, date = NULL, events = list(), ...)

MonthView(inputId, date = NULL, events = list(), ...)

YearView(inputId, date = NULL, events = list(), ...)
```

## Arguments

- inputId:

  Id of the Shiny input holding the currently displayed `date`.

- date:

  Initial displayed date (a `"YYYY-MM-DD"` string, or an R
  `Date`/`POSIXct`).

- events:

  Events to display: a `data.frame` (or list of rows) with `id`,
  `title`, `start`, `end`, and optionally `color`/`allDay`/
  `display`/`recurrence` columns. `start`/`end` accept
  `"YYYY-MM-DD HH:mm:ss"` strings or R `Date`/`POSIXct` values
  (converted automatically).

- ...:

  Other props (`startTime`, `endTime`, `intervalMinutes`,
  `withEventsDragAndDrop`, `withEventResize`, `withDragSlotSelect`,
  `businessHours`, `withCurrentTimeIndicator`, `firstDayOfWeek`,
  `withWeekNumbers`, ...). See <https://mantine.dev/schedule/day-view/>
  / <https://mantine.dev/schedule/week-view/> /
  <https://mantine.dev/schedule/month-view/> /
  <https://mantine.dev/schedule/year-view/>.

## Value

A `mantine_element` to nest inside
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md).

## Examples

``` r
if (FALSE) { # \dontrun{
DayView(
  inputId = "day1",
  date = Sys.Date(),
  events = data.frame(
    id = 1, title = "Team meeting",
    start = "2026-07-27 09:00:00", end = "2026-07-27 10:00:00",
    color = "blue"
  ),
  startTime = "08:00:00", endTime = "18:00:00"
)
} # }
```
