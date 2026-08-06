# Mantine Select (Shiny stateful input)

Mantine Select (Shiny stateful input)

## Usage

``` r
Select(inputId, label = NULL, value = NULL, ...)

updateMantineSelect(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` is synced on every
  selection.

- label:

  Field label.

- value:

  Initial value (or `NULL`).

- ...:

  Other props (`data`, `placeholder`, `searchable`, ...). See
  <https://mantine.dev/core/select/>.

- session:

  Session object passed to the Shiny server function.
