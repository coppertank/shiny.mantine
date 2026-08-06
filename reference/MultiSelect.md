# Mantine MultiSelect (Shiny stateful input, multiple selection)

Mantine MultiSelect (Shiny stateful input, multiple selection)

## Usage

``` r
MultiSelect(inputId, label = NULL, value = list(), ...)

updateMantineMultiSelect(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (a character vector) is
  synced on every selection.

- label:

  Field label.

- value:

  Initial value (a character vector). Mantine always expects an array
  for this component: use
  `character(0)`/[`list()`](https://rdrr.io/r/base/list.html), not
  `NULL`, for "nothing selected" (`NULL` would be serialized as JSON
  `null`, and MultiSelect calls `.map()` on its `value` internally).

- ...:

  Other props (`data`, `placeholder`, `searchable`, ...). See
  <https://mantine.dev/core/multi-select/>.

- session:

  Session object passed to the Shiny server function.
