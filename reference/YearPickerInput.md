# Mantine YearPickerInput (Shiny stateful input, year selection)

Mantine YearPickerInput (Shiny stateful input, year selection)

## Usage

``` r
YearPickerInput(inputId, label = NULL, value = NULL, ...)

updateMantineYearPickerInput(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (a `"YYYY-MM-DD"` string,
  first day of the year) is synced on selection.

- label:

  Field label.

- value:

  Initial value.

- ...:

  Other props. See <https://mantine.dev/dates/year-picker-input/>.

- session:

  Session object passed to the Shiny server function.
