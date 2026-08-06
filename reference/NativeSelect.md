# Mantine NativeSelect (Shiny stateful input, native `<select>`)

Mantine NativeSelect (Shiny stateful input, native `<select>`)

## Usage

``` r
NativeSelect(inputId, label = NULL, value = NULL, ...)

updateMantineNativeSelect(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` is synced to the selection.

- label:

  Field label.

- value:

  Initial value.

- ...:

  Other props (`data`, ...). See
  <https://mantine.dev/core/native-select/>.

- session:

  Session object passed to the Shiny server function.
