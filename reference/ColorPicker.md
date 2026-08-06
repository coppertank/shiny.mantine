# Mantine ColorPicker (Shiny stateful input, inline picker)

Mantine ColorPicker (Shiny stateful input, inline picker)

## Usage

``` r
ColorPicker(inputId, value = "#000000", ...)

updateMantineColorPicker(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` is synced to the selection.

- value:

  Initial value.

- ...:

  Other props (`format`, `swatches`, ...). See
  <https://mantine.dev/core/color-picker/>.

- session:

  Session object passed to the Shiny server function.
