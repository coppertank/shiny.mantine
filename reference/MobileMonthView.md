# Mantine MobileMonthView (`@mantine/schedule`): touch-optimized month view

A month grid with event indicators on top and a list of the selected
day's events at the bottom — designed for touch interaction, like a
mobile calendar app; no drag-and-drop. `input[[inputId]]` holds the
selected day (a `"YYYY-MM-DD"` string, the primary value, like every
other stateful input in this package);
`input[[paste0(inputId, "_month")]]` holds the displayed month
(secondary, changes on navigation alone). Update either from the server
with
[`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md)
(needs a `mantineId`; patch `selectedDate` and/or `date`).

## Usage

``` r
MobileMonthView(
  inputId,
  date = NULL,
  selectedDate = NULL,
  events = list(),
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input holding the selected day.

- date:

  Initial displayed month (a `"YYYY-MM-DD"` string, or an R
  `Date`/`POSIXct`).

- selectedDate:

  Initial selected day, or `NULL`.

- events:

  Events to display; see
  [`DayView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md)'s
  `events`.

- ...:

  Other props (`withWeekNumbers`, `firstDayOfWeek`, `highlightToday`,
  ...). See <https://mantine.dev/schedule/mobile-month-view/>.

## Value

A `mantine_element` to nest inside
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md).

## Examples

``` r
if (FALSE) { # \dontrun{
MobileMonthView(inputId = "mob1", date = Sys.Date(), selectedDate = Sys.Date())
} # }
```
