# Mantine YearPicker (always-visible inline year calendar)

Like
[`DatePicker()`](https://coppertank.github.io/shiny.mantine/reference/DatePicker.md),
but for year-level selection — the inline counterpart of
[`YearPickerInput()`](https://coppertank.github.io/shiny.mantine/reference/YearPickerInput.md).
See
[`MonthPicker()`](https://coppertank.github.io/shiny.mantine/reference/MonthPicker.md)
for month-level selection.

## Usage

``` r
YearPicker(inputId, value = NULL, ...)

updateMantineYearPicker(
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

- value:

  Initial value.

- ...:

  Other props (`type`, `numberOfColumns`, `presets`, ...). See
  <https://mantine.dev/dates/year-picker/>.

- session:

  Session object passed to the Shiny server function.
