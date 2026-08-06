# Mantine JsonInput (Shiny stateful input, with JSON validation)

Mantine JsonInput (Shiny stateful input, with JSON validation)

## Usage

``` r
JsonInput(inputId, label = NULL, value = "", ...)

updateMantineJsonInput(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (a string) is synced on
  every change.

- label:

  Field label.

- value:

  Initial value.

- ...:

  Other props (`formatOnBlur`, `validationError`, ...). See
  <https://mantine.dev/core/json-input/>.

- session:

  Session object passed to the Shiny server function.
