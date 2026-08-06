# Mantine PasswordInput (Shiny stateful input)

Mantine PasswordInput (Shiny stateful input)

## Usage

``` r
PasswordInput(inputId, label = NULL, value = "", ...)

updateMantinePasswordInput(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` is synced on every
  keystroke.

- label:

  Field label.

- value:

  Initial value.

- ...:

  Other props (`placeholder`, `description`, ...). See
  <https://mantine.dev/core/password-input/>.

- session:

  Session object passed to the Shiny server function.
