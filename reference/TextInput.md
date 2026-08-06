# Mantine TextInput (Shiny stateful input)

Mantine TextInput (Shiny stateful input)

## Usage

``` r
TextInput(inputId, label = NULL, value = "", ...)

updateMantineTextInput(
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

  Other props (`placeholder`, `description`, `error`, `disabled`, ...).
  See <https://mantine.dev/core/text-input/>.

- session:

  Session object passed to the Shiny server function.

## Value

A `mantine_element` to nest inside
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md).

## Note

The name is `updateMantineTextInput()` (not
[`updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html))
to avoid masking
[`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html)
when both packages are loaded together.
