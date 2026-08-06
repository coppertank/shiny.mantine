# Mantine DateInput (Shiny stateful input, text field with calendar)

Mantine DateInput (Shiny stateful input, text field with calendar)

## Usage

``` r
DateInput(inputId, label = NULL, value = NULL, ...)

updateMantineDateInput(
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

  Other props (`minDate`, `maxDate`, `valueFormat`, ...). See
  <https://mantine.dev/dates/date-input/>.

- session:

  Session object passed to the Shiny server function.
