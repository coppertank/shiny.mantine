# Mantine TagsInput (Shiny stateful input, free-form tags)

Mantine TagsInput (Shiny stateful input, free-form tags)

## Usage

``` r
TagsInput(inputId, label = NULL, value = list(), ...)

updateMantineTagsInput(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (a character vector) is
  synced on every change.

- label:

  Field label.

- value:

  Initial value (a character vector). As with
  [`MultiSelect()`](https://coppertank.github.io/shiny.mantine/reference/MultiSelect.md),
  use `character(0)`/[`list()`](https://rdrr.io/r/base/list.html) for
  "no tags", not `NULL`.

- ...:

  Other props (`data`, `placeholder`, ...). See
  <https://mantine.dev/core/tags-input/>.

- session:

  Session object passed to the Shiny server function.
