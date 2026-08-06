# Mantine resource schedule views (`@mantine/schedule`): resources as rows/columns

Like
[`DayView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md)/[`WeekView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md)/[`MonthView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md),
but events are grouped by `resources` (e.g. meeting rooms, staff
members) instead of a single timeline — each event's `resourceId`
matches a resource's `id`. Reports interactions to Shiny the same way as
[`DayView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md)
(see `?ScheduleViews` for the full list of suffixed input ids);
`_event_drop`/`_event_resize` payloads additionally include `resourceId`
when the event was moved to a different resource.

## Usage

``` r
ResourcesDayView(
  inputId,
  date = NULL,
  resources = list(),
  events = list(),
  ...
)

ResourcesWeekView(
  inputId,
  date = NULL,
  resources = list(),
  events = list(),
  ...
)

ResourcesMonthView(
  inputId,
  date = NULL,
  resources = list(),
  events = list(),
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input holding the currently displayed `date`.

- date:

  Initial displayed date (a `"YYYY-MM-DD"` string, or an R
  `Date`/`POSIXct`).

- resources:

  Resources to group by: a `data.frame` (or list of rows) with `id` and
  `label` columns.

- events:

  Events to display; see
  [`DayView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md)'s
  `events` — each event's `resourceId` should match one of `resources`'
  `id`.

- ...:

  Other props (`intervalMinutes`, `startTime`, `endTime`,
  `withEventsDragAndDrop`, `withEventResize`, `withDragSlotSelect`,
  `groups`, `groupLabelWidth`, `maxEventsPerTimeSlot`, ...). See
  <https://mantine.dev/schedule/resources-day-view/> /
  <https://mantine.dev/schedule/resources-week-view/> /
  <https://mantine.dev/schedule/resources-month-view/>.

## Value

A `mantine_element` to nest inside
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md).

## Details

`intervalMinutes` (default `60`) accepts values that divide evenly into
an hour (e.g. `15`, `30`) *or* whole numbers of hours (e.g. `120`,
`240`): values above `60` widen each time-slot column to span several
hours instead of subdividing within an hour — useful to fit a full day
in view compactly (e.g. `intervalMinutes = 240` renders 4-hour-wide
columns spanning midnight to midnight).

## Examples

``` r
if (FALSE) { # \dontrun{
ResourcesDayView(
  inputId = "rooms1",
  date = Sys.Date(),
  resources = data.frame(
    id = c("tokyo", "paris"),
    label = c("Meeting room: Tokyo", "Meeting room: Paris")
  ),
  events = data.frame(
    id = 1, title = "Team standup",
    start = "2026-07-27 09:00:00", end = "2026-07-27 10:00:00",
    resourceId = "tokyo"
  ),
  intervalMinutes = 240
)
} # }
```
