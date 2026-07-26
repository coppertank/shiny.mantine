#' @include mantine-element.R
NULL

# @mantine/dates: dates travel as plain "YYYY-MM-DD" strings (Mantine v9
# uses DateStringValue = string, not JS Date objects) — this makes them
# serializable to JSON with no special conversion. toDateString()
# conveniently converts an R Date/POSIXct into this format.

#' @keywords internal
toDateString <- function(x) {
  if (is.null(x)) {
    return(NULL)
  }
  if (is.character(x)) {
    return(x)
  }
  format(x, "%Y-%m-%d")
}

#' @keywords internal
toTimeString <- function(x) {
  if (is.null(x)) {
    return(NULL)
  }
  if (is.character(x)) {
    return(x)
  }
  format(x, "%H:%M:%S")
}

#' Mantine DateInput (Shiny stateful input, text field with calendar)
#' @param inputId Id of the Shiny input; `input[[inputId]]` (a
#'   `"YYYY-MM-DD"` string) is synced on selection.
#' @param label Field label.
#' @param value Initial value: a `"YYYY-MM-DD"` string, a `Date` object, or
#'   `NULL`.
#' @param ... Other props (`minDate`, `maxDate`, `valueFormat`, ...). See
#'   <https://mantine.dev/dates/date-input/>.
#' @export
DateInput <- function(inputId, label = NULL, value = NULL, ...) {
  mantineElement(
    "DateInput",
    inputId = inputId,
    label = label,
    value = toDateString(value),
    ...
  )
}

#' @rdname DateInput
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineDateInput <- function(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
) {
  session$sendCustomMessage(
    "shinyMantineUpdateInput",
    list(inputId = session$ns(inputId), value = toDateString(value))
  )
}

#' Mantine DatePickerInput (Shiny stateful input, dropdown calendar)
#' @param inputId Id of the Shiny input; `input[[inputId]]` (a
#'   `"YYYY-MM-DD"` string) is synced on selection.
#' @param label Field label.
#' @param value Initial value: a `"YYYY-MM-DD"` string, a `Date` object, or
#'   `NULL`.
#' @param ... Other props (`type` = `"default"`/`"multiple"`/`"range"`,
#'   `minDate`, `maxDate`, ...). See
#'   <https://mantine.dev/dates/date-picker-input/>.
#' @export
DatePickerInput <- function(inputId, label = NULL, value = NULL, ...) {
  mantineElement(
    "DatePickerInput",
    inputId = inputId,
    label = label,
    value = toDateString(value),
    ...
  )
}

#' @rdname DatePickerInput
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineDatePickerInput <- function(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
) {
  session$sendCustomMessage(
    "shinyMantineUpdateInput",
    list(inputId = session$ns(inputId), value = toDateString(value))
  )
}

#' Mantine DatePicker (always-visible inline calendar)
#' @param inputId Id of the Shiny input; `input[[inputId]]` (a
#'   `"YYYY-MM-DD"` string) is synced on selection.
#' @param value Initial value.
#' @param ... Other props (`type`, `minDate`, `maxDate`, ...). See
#'   <https://mantine.dev/dates/date-picker/>.
#' @export
DatePicker <- function(inputId, value = NULL, ...) {
  mantineElement(
    "DatePicker",
    inputId = inputId,
    value = toDateString(value),
    ...
  )
}

#' @rdname DatePicker
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineDatePicker <- function(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
) {
  session$sendCustomMessage(
    "shinyMantineUpdateInput",
    list(inputId = session$ns(inputId), value = toDateString(value))
  )
}

#' Mantine TimeInput (Shiny stateful input, native time field)
#' @param inputId Id of the Shiny input; `input[[inputId]]` (a `"HH:mm"`
#'   string) is synced on every change.
#' @param label Field label.
#' @param value Initial value (a `"HH:mm"` string).
#' @param ... Other props (`withSeconds`, `minTime`, `maxTime`, ...). See
#'   <https://mantine.dev/dates/time-input/>.
#' @export
TimeInput <- function(inputId, label = NULL, value = "", ...) {
  mantineElement(
    "TimeInput",
    inputId = inputId,
    label = label,
    value = value,
    ...
  )
}

#' Mantine MonthPickerInput (Shiny stateful input, month/year selection)
#' @param inputId Id of the Shiny input; `input[[inputId]]` (a
#'   `"YYYY-MM-DD"` string, first day of the month) is synced on selection.
#' @param label Field label.
#' @param value Initial value.
#' @param ... Other props. See <https://mantine.dev/dates/month-picker-input/>.
#' @export
MonthPickerInput <- function(inputId, label = NULL, value = NULL, ...) {
  mantineElement(
    "MonthPickerInput",
    inputId = inputId,
    label = label,
    value = toDateString(value),
    ...
  )
}

#' @rdname MonthPickerInput
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineMonthPickerInput <- function(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
) {
  session$sendCustomMessage(
    "shinyMantineUpdateInput",
    list(inputId = session$ns(inputId), value = toDateString(value))
  )
}

#' Mantine YearPickerInput (Shiny stateful input, year selection)
#' @param inputId Id of the Shiny input; `input[[inputId]]` (a
#'   `"YYYY-MM-DD"` string, first day of the year) is synced on selection.
#' @param label Field label.
#' @param value Initial value.
#' @param ... Other props. See <https://mantine.dev/dates/year-picker-input/>.
#' @export
YearPickerInput <- function(inputId, label = NULL, value = NULL, ...) {
  mantineElement(
    "YearPickerInput",
    inputId = inputId,
    label = label,
    value = toDateString(value),
    ...
  )
}

#' @rdname YearPickerInput
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineYearPickerInput <- function(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
) {
  session$sendCustomMessage(
    "shinyMantineUpdateInput",
    list(inputId = session$ns(inputId), value = toDateString(value))
  )
}

#' Mantine DateTimePicker (Shiny stateful input, date + time)
#' @param inputId Id of the Shiny input; `input[[inputId]]` (a
#'   `"YYYY-MM-DD HH:mm:ss"` string) is synced on selection.
#' @param label Field label.
#' @param value Initial value.
#' @param ... Other props. See <https://mantine.dev/dates/date-time-picker/>.
#' @export
DateTimePicker <- function(inputId, label = NULL, value = NULL, ...) {
  mantineElement(
    "DateTimePicker",
    inputId = inputId,
    label = label,
    value = value,
    ...
  )
}

#' @rdname DateTimePicker
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineDateTimePicker <- function(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
) {
  session$sendCustomMessage(
    "shinyMantineUpdateInput",
    list(inputId = session$ns(inputId), value = value)
  )
}

#' Mantine DatesProvider (locale/date format for its children)
#' @param ... Props (`locale`, `firstDayOfWeek`, ...) and children. See
#'   <https://mantine.dev/dates/dates-provider/>.
#' @export
DatesProvider <- displayComponent("DatesProvider")

#' Mantine TimePicker (Shiny stateful input, dropdown/scroll time picker)
#'
#' Distinct from [TimeInput()]: a dedicated picker UI (hour/minute/second
#' columns) instead of a native `<input type="time">` field.
#' @param inputId Id of the Shiny input; `input[[inputId]]` (a `"HH:mm"` or
#'   `"HH:mm:ss"` string) is synced on selection.
#' @param label Field label.
#' @param value Initial value (a `"HH:mm"`/`"HH:mm:ss"` string).
#' @param ... Other props (`withSeconds`, `format`, `min`, `max`, ...). See
#'   <https://mantine.dev/dates/time-picker/>.
#' @export
TimePicker <- function(inputId, label = NULL, value = "", ...) {
  mantineElement(
    "TimePicker",
    inputId = inputId,
    label = label,
    value = value,
    ...
  )
}

#' @rdname TimePicker
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineTimePicker <- function(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
) {
  session$sendCustomMessage(
    "shinyMantineUpdateInput",
    list(inputId = session$ns(inputId), value = value)
  )
}

#' Mantine TimeGrid (Shiny stateful input, grid of selectable time slots)
#' @param inputId Id of the Shiny input; `input[[inputId]]` (a `"HH:mm"`
#'   string, or `NULL`) is synced on selection.
#' @param data A character vector of selectable times (e.g. `c("09:00",
#'   "09:30", "10:00")`).
#' @param value Initial value.
#' @param ... Other props (`format`, `simpleGridProps`, ...). See
#'   <https://mantine.dev/dates/time-grid/>.
#' @export
TimeGrid <- function(inputId, data, value = NULL, ...) {
  mantineElement("TimeGrid", inputId = inputId, data = data, value = value, ...)
}

#' @rdname TimeGrid
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineTimeGrid <- function(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
) {
  session$sendCustomMessage(
    "shinyMantineUpdateInput",
    list(inputId = session$ns(inputId), value = value)
  )
}

#' Mantine MiniCalendar (compact single-week calendar strip)
#' @param inputId Id of the Shiny input; `input[[inputId]]` (a
#'   `"YYYY-MM-DD"` string) is synced on selection.
#' @param value Initial value.
#' @param ... Other props. See <https://mantine.dev/dates/mini-calendar/>.
#' @export
MiniCalendar <- function(inputId, value = NULL, ...) {
  mantineElement(
    "MiniCalendar",
    inputId = inputId,
    value = toDateString(value),
    ...
  )
}

#' @rdname MiniCalendar
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineMiniCalendar <- function(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
) {
  session$sendCustomMessage(
    "shinyMantineUpdateInput",
    list(inputId = session$ns(inputId), value = toDateString(value))
  )
}

#' Mantine InlineDateTimePicker (date + time picker, always visible)
#'
#' Like [DateTimePicker()], but rendered inline (calendar + time input +
#' submit button always visible) instead of behind a popover/input field.
#' @param inputId Id of the Shiny input; `input[[inputId]]` (a
#'   `"YYYY-MM-DD HH:mm:ss"` string) is synced when the submit button is
#'   clicked.
#' @param value Initial value.
#' @param ... Other props (`withSeconds`, `submitButtonProps`, ...). See
#'   <https://mantine.dev/dates/inline-date-time-picker/>.
#' @export
InlineDateTimePicker <- function(inputId, value = NULL, ...) {
  mantineElement("InlineDateTimePicker", inputId = inputId, value = value, ...)
}

#' @rdname InlineDateTimePicker
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineInlineDateTimePicker <- function(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
) {
  session$sendCustomMessage(
    "shinyMantineUpdateInput",
    list(inputId = session$ns(inputId), value = value)
  )
}

#' Mantine MonthPicker (always-visible inline month calendar)
#'
#' Like [DatePicker()], but for month-level selection — the inline
#' counterpart of [MonthPickerInput()]. Use [YearPicker()] for year-level
#' selection.
#' @rdname MonthPicker
#' @param inputId Id of the Shiny input; `input[[inputId]]` (a
#'   `"YYYY-MM-DD"` string, first day of the month) is synced on
#'   selection.
#' @param value Initial value.
#' @param ... Other props (`type` = `"default"`/`"multiple"`/`"range"`,
#'   `numberOfColumns`, `presets`, ...). See
#'   <https://mantine.dev/dates/month-picker/>.
#' @export
MonthPicker <- function(inputId, value = NULL, ...) {
  mantineElement("MonthPicker", inputId = inputId, value = toDateString(value), ...)
}

#' @rdname MonthPicker
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineMonthPicker <- function(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
) {
  session$sendCustomMessage(
    "shinyMantineUpdateInput",
    list(inputId = session$ns(inputId), value = toDateString(value))
  )
}

#' Mantine YearPicker (always-visible inline year calendar)
#'
#' Like [DatePicker()], but for year-level selection — the inline
#' counterpart of [YearPickerInput()]. See [MonthPicker()] for month-level
#' selection.
#' @rdname YearPicker
#' @param inputId Id of the Shiny input; `input[[inputId]]` (a
#'   `"YYYY-MM-DD"` string, first day of the year) is synced on selection.
#' @param value Initial value.
#' @param ... Other props (`type`, `numberOfColumns`, `presets`, ...). See
#'   <https://mantine.dev/dates/year-picker/>.
#' @export
YearPicker <- function(inputId, value = NULL, ...) {
  mantineElement("YearPicker", inputId = inputId, value = toDateString(value), ...)
}

#' @rdname YearPicker
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineYearPicker <- function(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
) {
  session$sendCustomMessage(
    "shinyMantineUpdateInput",
    list(inputId = session$ns(inputId), value = toDateString(value))
  )
}

#' Mantine TimeValue (formats a time string/Date for display)
#'
#' Purely a display component (not a Shiny input) — renders `value`
#' formatted as 12h/24h time, e.g. inside a [Text()].
#' @param value Time to format: a `"HH:mm:ss"` string, or a `Date`/`POSIXct`.
#' @param ... Other props (`format` = `"12h"`/`"24h"`, `withSeconds`,
#'   `amPmLabels`, ...). See <https://mantine.dev/dates/time-value/>.
#' @export
#' @examples
#' \dontrun{
#' TimeValue(value = "18:45:34", format = "12h")
#' }
TimeValue <- function(value, ...) {
  mantineElement("TimeValue", value = toTimeString(value), ...)
}
