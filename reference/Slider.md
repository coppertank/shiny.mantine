# Mantine Slider (Shiny stateful input)

Mantine Slider (Shiny stateful input)

## Usage

``` r
Slider(inputId, value = 0, ...)

updateMantineSlider(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` is synced by dragging the
  handle.

- value:

  Initial value.

- ...:

  Other props (`min`, `max`, `step`, `marks`, `label`, `color`, ...).
  See <https://mantine.dev/core/slider/>.

- session:

  Session object passed to the Shiny server function.
