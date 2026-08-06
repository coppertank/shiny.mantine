# Mantine DatePicker (always-visible inline calendar)

Mantine DatePicker (always-visible inline calendar)

## Usage

``` r
DatePicker(inputId, value = NULL, ...)

updateMantineDatePicker(
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

  Other props (`type`, `minDate`, `maxDate`, ...). See
  <https://mantine.dev/dates/date-picker/>.

- session:

  Session object passed to the Shiny server function.
