# Mantine DatePickerInput (Shiny stateful input, dropdown calendar)

Mantine DatePickerInput (Shiny stateful input, dropdown calendar)

## Usage

``` r
DatePickerInput(inputId, label = NULL, value = NULL, ...)

updateMantineDatePickerInput(
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

- label:

  Field label.

- value:

  Initial value: a `"YYYY-MM-DD"` string, a `Date` object, or `NULL`.

- ...:

  Other props (`type` = `"default"`/`"multiple"`/`"range"`, `minDate`,
  `maxDate`, ...). See <https://mantine.dev/dates/date-picker-input/>.

- session:

  Session object passed to the Shiny server function.
