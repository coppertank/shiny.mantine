# Mantine MonthPickerInput (Shiny stateful input, month/year selection)

Mantine MonthPickerInput (Shiny stateful input, month/year selection)

## Usage

``` r
MonthPickerInput(inputId, label = NULL, value = NULL, ...)

updateMantineMonthPickerInput(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (a `"YYYY-MM-DD"` string,
  first day of the month) is synced on selection.

- label:

  Field label.

- value:

  Initial value.

- ...:

  Other props. See <https://mantine.dev/dates/month-picker-input/>.

- session:

  Session object passed to the Shiny server function.
