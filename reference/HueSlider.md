# Mantine HueSlider (Shiny stateful input, standalone hue channel)

The hue-channel slider
[`ColorPicker()`](https://coppertank.github.io/shiny.mantine/reference/ColorPicker.md)
uses internally, usable on its own if you only need to let the user pick
a hue (0-359) — e.g. driving your own custom color composition instead
of a full
[`ColorPicker()`](https://coppertank.github.io/shiny.mantine/reference/ColorPicker.md).

## Usage

``` r
HueSlider(inputId, value = 0, ...)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (0-359) is synced by
  dragging.

- value:

  Initial value.

- ...:

  Other props (`size`, ...). See
  <https://mantine.dev/core/color-picker/>.
