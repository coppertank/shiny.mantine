# Mantine DateTimePicker (Shiny stateful input, date + time)

Mantine DateTimePicker (Shiny stateful input, date + time)

## Usage

``` r
DateTimePicker(inputId, label = NULL, value = NULL, ...)

updateMantineDateTimePicker(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (a `"YYYY-MM-DD HH:mm:ss"`
  string) is synced on selection.

- label:

  Field label.

- value:

  Initial value.

- ...:

  Other props. See <https://mantine.dev/dates/date-time-picker/>.

- session:

  Session object passed to the Shiny server function.
