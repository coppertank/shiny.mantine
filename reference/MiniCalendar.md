# Mantine MiniCalendar (compact single-week calendar strip)

Mantine MiniCalendar (compact single-week calendar strip)

## Usage

``` r
MiniCalendar(inputId, value = NULL, ...)

updateMantineMiniCalendar(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (a `"YYYY-MM-DD"` string) is
  synced on selection.

- value:

  Initial value.

- ...:

  Other props. See <https://mantine.dev/dates/mini-calendar/>.

- session:

  Session object passed to the Shiny server function.
