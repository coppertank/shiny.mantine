# Mantine Cascader (Shiny stateful input, hierarchical cascading selection)

Lets users drill down through nested options column by column (or, with
`withColumns = FALSE`, as a flat searchable list of full paths) — e.g.
picking a location through Continent \> Country \> City. Unlike
[`TreeSelect()`](https://coppertank.github.io/shiny.mantine/reference/TreeSelect.md)
(a flat popover tree), each level opens its own column next to the
previous one.

## Usage

``` r
Cascader(inputId, data, value = NULL, ...)

updateMantineCascader(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (a character vector, the
  path from root to the selected node) is synced on every selection.

- data:

  Hierarchical options: a list of
  `list(value=, label=, children=, disabled=)`, `children` nested the
  same way. Every `value` must be unique across the whole tree.

- value:

  Initial value: a character vector (the path from root to the selected
  node), or `NULL` for nothing selected. Only leaf nodes are selectable
  unless `changeOnSelect = TRUE`.

- ...:

  Other props (`changeOnSelect`, `expandTrigger` = `"click"`/`"hover"`,
  `searchable`, `withColumns`, `clearable`, `maxDisplayedLevels`, ...).
  See <https://mantine.dev/core/cascader/>.

- session:

  Session object passed to the Shiny server function.

## Examples

``` r
if (FALSE) { # \dontrun{
Cascader(
  inputId = "location",
  label = "Location",
  data = list(
    list(value = "asia", label = "Asia", children = list(
      list(value = "jp", label = "Japan", children = list(
        list(value = "tokyo", label = "Tokyo"),
        list(value = "osaka", label = "Osaka")
      ))
    ))
  )
)
} # }
```
