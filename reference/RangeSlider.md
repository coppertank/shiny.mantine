# Mantine RangeSlider (Shiny stateful input, range)

Mantine RangeSlider (Shiny stateful input, range)

## Usage

``` r
RangeSlider(inputId, value = c(20, 80), ...)

updateMantineRangeSlider(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (a vector of 2 numbers) is
  synced by dragging the handles.

- value:

  Initial value, a vector of 2 numbers (e.g. `c(20, 80)`).

- ...:

  Other props (`min`, `max`, `step`, `marks`, ...). See
  <https://mantine.dev/core/slider/#rangeslider>.

- session:

  Session object passed to the Shiny server function.
