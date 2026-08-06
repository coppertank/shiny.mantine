# Mantine TreeSelect (select input with hierarchical data)

Behaves like
[`Select()`](https://coppertank.github.io/shiny.mantine/reference/Select.md)/[`MultiSelect()`](https://coppertank.github.io/shiny.mantine/reference/MultiSelect.md)
but for tree-shaped `data`.

## Usage

``` r
TreeSelect(inputId, data, value = NULL, ...)

updateMantineTreeSelect(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` is synced to the selected
  value(s).

- data:

  Tree data: a list of `list(value=, label=, children=...)`.

- value:

  Initial value: a string, or a character vector if `multiple = TRUE`.

- ...:

  Other props (`multiple`, `placeholder`, ...). See
  <https://mantine.dev/core/tree-select/>.

- session:

  Session object passed to the Shiny server function.
