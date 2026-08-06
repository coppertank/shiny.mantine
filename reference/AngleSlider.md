# Mantine AngleSlider (Shiny stateful input, 0-360 degree dial)

A circular dial for picking an angle/direction (0-359 degrees) — e.g. a
gradient angle or a compass-style direction picker.

## Usage

``` r
AngleSlider(inputId, value = 0, ...)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (0-359) is synced by
  dragging.

- value:

  Initial value.

- ...:

  Other props (`size`, `marks`, `step`, ...). See
  <https://mantine.dev/core/angle-slider/>.
