# Mantine ColorInput (Shiny stateful input)

Mantine ColorInput (Shiny stateful input)

## Usage

``` r
ColorInput(inputId, label = NULL, value = "#000000", ...)

updateMantineColorInput(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (a color string) is synced
  to the selection.

- label:

  Field label.

- value:

  Initial value (e.g. `"#228BE6"`).

- ...:

  Other props (`format`, `swatches`, ...). See
  <https://mantine.dev/core/color-input/>.

- session:

  Session object passed to the Shiny server function.
