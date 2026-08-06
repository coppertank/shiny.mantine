# Mantine Autocomplete (Shiny stateful input)

Mantine Autocomplete (Shiny stateful input)

## Usage

``` r
Autocomplete(inputId, label = NULL, value = "", ...)

updateMantineAutocomplete(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` is synced on every
  keystroke/selection.

- label:

  Field label.

- value:

  Initial value.

- ...:

  Other props (`data`, `placeholder`, `limit`, ...). See
  <https://mantine.dev/core/autocomplete/>.

- session:

  Session object passed to the Shiny server function.
