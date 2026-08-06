# Mantine NumberInput (Shiny stateful input)

Mantine NumberInput (Shiny stateful input)

## Usage

``` r
NumberInput(inputId, label = NULL, value = NULL, ...)

updateMantineNumberInput(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` is synced on every change.

- label:

  Field label.

- value:

  Initial value (a number or `NULL`).

- ...:

  Other props (`min`, `max`, `step`, `prefix`, `suffix`, ...). See
  <https://mantine.dev/core/number-input/>.

- session:

  Session object passed to the Shiny server function.
