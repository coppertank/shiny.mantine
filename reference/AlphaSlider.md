# Mantine AlphaSlider (Shiny stateful input, standalone alpha channel)

The alpha-channel slider
[`ColorPicker()`](https://coppertank.github.io/shiny.mantine/reference/ColorPicker.md)
uses internally, usable on its own — e.g. an opacity control paired with
your own color swatch.

## Usage

``` r
AlphaSlider(inputId, color, value = 1, ...)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (0-1) is synced by dragging.

- color:

  Base color the alpha gradient is rendered against (e.g. `"#228be6"` or
  `"rgba(34, 139, 230, 1)"`).

- value:

  Initial value.

- ...:

  Other props (`size`, ...). See
  <https://mantine.dev/core/color-picker/>.
