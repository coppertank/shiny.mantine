#' @include mantine-element.R
#' @include Dates.R
#' @include Charts.R
NULL

# @mantine/schedule: calendar/scheduling views (day/week/month/year/agenda,
# plus resource-grouped variants). Every event is a plain list matching
# Mantine's shape (`id`, `title`, `start`, `end`, `color`, optionally
# `resourceId`/`allDay`/`display`/`recurrence`); `start`/`end` are
# "YYYY-MM-DD HH:mm:ss" strings, converted automatically from R
# Date/POSIXct via scheduleEvents() below (same convention as chartData()
# for chart data).
#
# Render-prop customization (renderEvent, renderEventBody,
# renderResourceLabel, renderGroupLabel, renderHeader, getTimeSlotProps,
# getCurrentTime) and per-event predicates (canDragEvent, canResizeEvent)
# are JS functions that cannot cross the R/JSON bridge and are not
# exposed — every event is draggable/resizable whenever
# `withEventsDragAndDrop`/`withEventResize` is set, and default rendering
# is used throughout (same trade-off already made for
# Combobox()/TableOfContents()/OverflowList()).
#
# Distinct interactions are reported to Shiny under suffixed input ids off
# the view's own `inputId` (same convention as Dropzone()'s
# `<inputId>_rejected`) — see `?DayView` for the full list. Update
# `date`/`events`/any other prop from the server with
# [updateMantineProps()] (needs a `mantineId`).

#' @keywords internal
scheduleEvents <- function(events) {
  rows <- chartData(events)
  lapply(rows, function(row) {
    if (!is.null(row$start)) {
      row$start <- toDateTimeString(row$start)
    }
    if (!is.null(row$end)) {
      row$end <- toDateTimeString(row$end)
    }
    row
  })
}

#' @keywords internal
scheduleView <- function(name, inputId, date, events, ...) {
  mantineElement(
    name,
    inputId = inputId,
    date = toDateString(date),
    events = scheduleEvents(events),
    ...
  )
}

#' Mantine schedule views (`@mantine/schedule`): Day/Week/Month/Year
#'
#' Calendar views for a single resource (see [ResourcesDayView()] and
#' family for the resource-grouped equivalents). Fully controlled:
#' `input[[inputId]]` holds the currently displayed `date` (a
#' `"YYYY-MM-DD"` string), synced whenever the user navigates. Several
#' other interactions are additionally reported under suffixed input ids:
#' - `input[[paste0(inputId, "_event_click")]]` — clicked event's `id`.
#' - `input[[paste0(inputId, "_slot_click")]]` — clicked time slot (shape
#'   depends on the view — usually a datetime string).
#' - `input[[paste0(inputId, "_all_day_click")]]` — clicked all-day slot's
#'   date (`DayView()`/`WeekView()`).
#' - `input[[paste0(inputId, "_slot_select")]]` — `list(rangeStart=,
#'   rangeEnd=)` after a drag-to-select (needs `withDragSlotSelect =
#'   TRUE`), for creating a new event server-side.
#' - `input[[paste0(inputId, "_event_drop")]]` — `list(eventId=,
#'   newStart=, newEnd=)` after a drag-and-drop (needs
#'   `withEventsDragAndDrop = TRUE`); the view's own display already moves
#'   the event immediately (no server round-trip needed for the visual
#'   feedback), so this is meant for persisting the change server-side.
#' - `input[[paste0(inputId, "_event_resize")]]` — same shape, after a
#'   resize (needs `withEventResize = TRUE`).
#'
#' @rdname ScheduleViews
#' @param inputId Id of the Shiny input holding the currently displayed
#'   `date`.
#' @param date Initial displayed date (a `"YYYY-MM-DD"` string, or an R
#'   `Date`/`POSIXct`).
#' @param events Events to display: a `data.frame` (or list of rows) with
#'   `id`, `title`, `start`, `end`, and optionally `color`/`allDay`/
#'   `display`/`recurrence` columns. `start`/`end` accept
#'   `"YYYY-MM-DD HH:mm:ss"` strings or R `Date`/`POSIXct` values
#'   (converted automatically).
#' @param ... Other props (`startTime`, `endTime`, `intervalMinutes`,
#'   `withEventsDragAndDrop`, `withEventResize`, `withDragSlotSelect`,
#'   `businessHours`, `withCurrentTimeIndicator`, `firstDayOfWeek`,
#'   `withWeekNumbers`, ...). See <https://mantine.dev/schedule/day-view/>
#'   / <https://mantine.dev/schedule/week-view/> /
#'   <https://mantine.dev/schedule/month-view/> /
#'   <https://mantine.dev/schedule/year-view/>.
#' @return A `mantine_element` to nest inside [MantineProvider()].
#' @export
#' @examples
#' \dontrun{
#' DayView(
#'   inputId = "day1",
#'   date = Sys.Date(),
#'   events = data.frame(
#'     id = 1, title = "Team meeting",
#'     start = "2026-07-27 09:00:00", end = "2026-07-27 10:00:00",
#'     color = "blue"
#'   ),
#'   startTime = "08:00:00", endTime = "18:00:00"
#' )
#' }
DayView <- function(inputId, date = NULL, events = list(), ...) {
  scheduleView("DayView", inputId, date, events, ...)
}

#' @rdname ScheduleViews
#' @export
WeekView <- function(inputId, date = NULL, events = list(), ...) {
  scheduleView("WeekView", inputId, date, events, ...)
}

#' @rdname ScheduleViews
#' @export
MonthView <- function(inputId, date = NULL, events = list(), ...) {
  scheduleView("MonthView", inputId, date, events, ...)
}

#' @rdname ScheduleViews
#' @export
YearView <- function(inputId, date = NULL, events = list(), ...) {
  scheduleView("YearView", inputId, date, events, ...)
}

#' Mantine resource schedule views (`@mantine/schedule`): resources as rows/columns
#'
#' Like [DayView()]/[WeekView()]/[MonthView()], but events are grouped by
#' `resources` (e.g. meeting rooms, staff members) instead of a single
#' timeline — each event's `resourceId` matches a resource's `id`. Reports
#' interactions to Shiny the same way as [DayView()] (see `?ScheduleViews`
#' for the full list of suffixed input ids); `_event_drop`/`_event_resize`
#' payloads additionally include `resourceId` when the event was moved to
#' a different resource.
#'
#' `intervalMinutes` (default `60`) accepts values that divide evenly into
#' an hour (e.g. `15`, `30`) *or* whole numbers of hours (e.g. `120`,
#' `240`): values above `60` widen each time-slot column to span several
#' hours instead of subdividing within an hour — useful to fit a full day
#' in view compactly (e.g. `intervalMinutes = 240` renders 4-hour-wide
#' columns spanning midnight to midnight).
#'
#' @rdname ResourcesScheduleViews
#' @param inputId Id of the Shiny input holding the currently displayed
#'   `date`.
#' @param date Initial displayed date (a `"YYYY-MM-DD"` string, or an R
#'   `Date`/`POSIXct`).
#' @param resources Resources to group by: a `data.frame` (or list of
#'   rows) with `id` and `label` columns.
#' @param events Events to display; see [DayView()]'s `events` — each
#'   event's `resourceId` should match one of `resources`' `id`.
#' @param ... Other props (`intervalMinutes`, `startTime`, `endTime`,
#'   `withEventsDragAndDrop`, `withEventResize`, `withDragSlotSelect`,
#'   `groups`, `groupLabelWidth`, `maxEventsPerTimeSlot`, ...). See
#'   <https://mantine.dev/schedule/resources-day-view/> /
#'   <https://mantine.dev/schedule/resources-week-view/> /
#'   <https://mantine.dev/schedule/resources-month-view/>.
#' @return A `mantine_element` to nest inside [MantineProvider()].
#' @export
#' @examples
#' \dontrun{
#' ResourcesDayView(
#'   inputId = "rooms1",
#'   date = Sys.Date(),
#'   resources = data.frame(
#'     id = c("tokyo", "paris"),
#'     label = c("Meeting room: Tokyo", "Meeting room: Paris")
#'   ),
#'   events = data.frame(
#'     id = 1, title = "Team standup",
#'     start = "2026-07-27 09:00:00", end = "2026-07-27 10:00:00",
#'     resourceId = "tokyo"
#'   ),
#'   intervalMinutes = 240
#' )
#' }
ResourcesDayView <- function(inputId, date = NULL, resources = list(), events = list(), ...) {
  scheduleView("ResourcesDayView", inputId, date, events, resources = chartData(resources), ...)
}

#' @rdname ResourcesScheduleViews
#' @export
ResourcesWeekView <- function(inputId, date = NULL, resources = list(), events = list(), ...) {
  scheduleView("ResourcesWeekView", inputId, date, events, resources = chartData(resources), ...)
}

#' @rdname ResourcesScheduleViews
#' @export
ResourcesMonthView <- function(inputId, date = NULL, resources = list(), events = list(), ...) {
  scheduleView("ResourcesMonthView", inputId, date, events, resources = chartData(resources), ...)
}

#' Mantine AgendaView (`@mantine/schedule`): events as a vertical list
#'
#' Displays events in a scrollable list grouped by date, in chronological
#' order, over a fixed `[rangeStart, rangeEnd]` window — no drag-and-drop,
#' no `date`/`onDateChange` navigation of its own (the app controls the
#' visible range directly). `input[[paste0(inputId, "_event_click")]]`
#' receives the clicked event's `id`.
#'
#' @param inputId Id used as the prefix for this view's Shiny inputs.
#' @param rangeStart,rangeEnd Start/end of the displayed date range (each a
#'   `"YYYY-MM-DD"` string, or an R `Date`/`POSIXct`).
#' @param events Events to display; see [DayView()]'s `events`.
#' @param ... Other props (`headerFormat`, `dateHeaderFormat`, `locale`,
#'   `labels`, ...). See <https://mantine.dev/schedule/agenda-view/>.
#' @return A `mantine_element` to nest inside [MantineProvider()].
#' @export
#' @examples
#' \dontrun{
#' AgendaView(
#'   inputId = "agenda1",
#'   rangeStart = Sys.Date(), rangeEnd = Sys.Date() + 7,
#'   events = data.frame(
#'     id = 1, title = "Team standup",
#'     start = "2026-07-27 09:00:00", end = "2026-07-27 09:30:00"
#'   )
#' )
#' }
AgendaView <- function(inputId, rangeStart, rangeEnd, events = list(), ...) {
  mantineElement(
    "AgendaView",
    inputId = inputId,
    rangeStart = toDateString(rangeStart),
    rangeEnd = toDateString(rangeEnd),
    events = scheduleEvents(events),
    ...
  )
}

#' Mantine MobileMonthView (`@mantine/schedule`): touch-optimized month view
#'
#' A month grid with event indicators on top and a list of the selected
#' day's events at the bottom — designed for touch interaction, like a
#' mobile calendar app; no drag-and-drop. `input[[inputId]]` holds the
#' selected day (a `"YYYY-MM-DD"` string, the primary value, like every
#' other stateful input in this package); `input[[paste0(inputId,
#' "_month")]]` holds the displayed month (secondary, changes on
#' navigation alone). Update either from the server with
#' [updateMantineProps()] (needs a `mantineId`; patch `selectedDate`
#' and/or `date`).
#'
#' @param inputId Id of the Shiny input holding the selected day.
#' @param date Initial displayed month (a `"YYYY-MM-DD"` string, or an R
#'   `Date`/`POSIXct`).
#' @param selectedDate Initial selected day, or `NULL`.
#' @param events Events to display; see [DayView()]'s `events`.
#' @param ... Other props (`withWeekNumbers`, `firstDayOfWeek`,
#'   `highlightToday`, ...). See
#'   <https://mantine.dev/schedule/mobile-month-view/>.
#' @return A `mantine_element` to nest inside [MantineProvider()].
#' @export
#' @examples
#' \dontrun{
#' MobileMonthView(inputId = "mob1", date = Sys.Date(), selectedDate = Sys.Date())
#' }
MobileMonthView <- function(inputId, date = NULL, selectedDate = NULL, events = list(), ...) {
  mantineElement(
    "MobileMonthView",
    inputId = inputId,
    date = toDateString(date),
    selectedDate = toDateString(selectedDate),
    events = scheduleEvents(events),
    ...
  )
}

#' Mantine Schedule (`@mantine/schedule`): unified view with built-in switching
#'
#' Combines [DayView()]/[WeekView()]/[MonthView()]/[YearView()] behind one
#' component with its own header controls for switching between them.
#' `input[[inputId]]` holds the displayed `date`;
#' `input[[paste0(inputId, "_view")]]` holds the active view level (e.g.
#' `"day"`/`"week"`/`"month"`/`"year"`). Other interactions are reported
#' the same way as [DayView()] (see `?ScheduleViews`).
#'
#' @param inputId Id of the Shiny input holding the displayed `date`.
#' @param date Initial displayed date (a `"YYYY-MM-DD"` string, or an R
#'   `Date`/`POSIXct`).
#' @param view Initial view level (e.g. `"day"`, `"week"`, `"month"`,
#'   `"year"`).
#' @param events Events to display; see [DayView()]'s `events`.
#' @param ... Other props (`dayViewProps`, `weekViewProps`,
#'   `monthViewProps`, `yearViewProps` — each a named list forwarded to
#'   the matching view — `withAgenda`, `withEventsDragAndDrop`,
#'   `withEventResize`, ...). See <https://mantine.dev/schedule/schedule/>.
#' @return A `mantine_element` to nest inside [MantineProvider()].
#' @export
#' @examples
#' \dontrun{
#' Schedule(
#'   inputId = "sched1", view = "week",
#'   events = data.frame(
#'     id = 1, title = "Team standup",
#'     start = "2026-07-27 09:00:00", end = "2026-07-27 09:30:00"
#'   )
#' )
#' }
Schedule <- function(inputId, date = NULL, view = NULL, events = list(), ...) {
  mantineElement(
    "Schedule",
    inputId = inputId,
    date = toDateString(date),
    view = view,
    events = scheduleEvents(events),
    ...
  )
}
