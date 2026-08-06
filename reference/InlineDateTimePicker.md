# Mantine InlineDateTimePicker (date + time picker, always visible)

Like
[`DateTimePicker()`](https://coppertank.github.io/shiny.mantine/reference/DateTimePicker.md),
but rendered inline (calendar + time input + submit button always
visible) instead of behind a popover/input field.

## Usage

``` r
InlineDateTimePicker(inputId, value = NULL, ...)

updateMantineInlineDateTimePicker(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (a `"YYYY-MM-DD HH:mm:ss"`
  string) is synced when the submit button is clicked.

- value:

  Initial value.

- ...:

  Other props (`withSeconds`, `submitButtonProps`, ...). See
  <https://mantine.dev/dates/inline-date-time-picker/>.

- session:

  Session object passed to the Shiny server function.
