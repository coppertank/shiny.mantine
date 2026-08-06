# Mantine TimePicker (Shiny stateful input, dropdown/scroll time picker)

Distinct from
[`TimeInput()`](https://coppertank.github.io/shiny.mantine/reference/TimeInput.md):
a dedicated picker UI (hour/minute/second columns) instead of a native
`<input type="time">` field.

## Usage

``` r
TimePicker(inputId, label = NULL, value = "", ...)

updateMantineTimePicker(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (a `"HH:mm"` or `"HH:mm:ss"`
  string) is synced on selection.

- label:

  Field label.

- value:

  Initial value (a `"HH:mm"`/`"HH:mm:ss"` string).

- ...:

  Other props (`withSeconds`, `format`, `min`, `max`, ...). See
  <https://mantine.dev/dates/time-picker/>.

- session:

  Session object passed to the Shiny server function.
