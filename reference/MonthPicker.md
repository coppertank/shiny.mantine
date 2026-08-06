# Mantine MonthPicker (always-visible inline month calendar)

Like
[`DatePicker()`](https://coppertank.github.io/shiny.mantine/reference/DatePicker.md),
but for month-level selection — the inline counterpart of
[`MonthPickerInput()`](https://coppertank.github.io/shiny.mantine/reference/MonthPickerInput.md).
Use
[`YearPicker()`](https://coppertank.github.io/shiny.mantine/reference/YearPicker.md)
for year-level selection.

## Usage

``` r
MonthPicker(inputId, value = NULL, ...)

updateMantineMonthPicker(
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

- value:

  Initial value.

- ...:

  Other props (`type` = `"default"`/`"multiple"`/`"range"`,
  `numberOfColumns`, `presets`, ...). See
  <https://mantine.dev/dates/month-picker/>.

- session:

  Session object passed to the Shiny server function.
