# Mantine Tree (hierarchical data display)

Renders nested/expandable nodes from `data` (a list of
`list(value=, label=, children=list(...))`). If `inputId` is set,
clicking a node reports its `value` to `input[[inputId]]`.

## Usage

``` r
Tree(inputId = NULL, data, ...)
```

## Arguments

- inputId:

  If set, `input[[inputId]]` receives the clicked node's `value`.

- data:

  Tree data: a list of `list(value=, label=, children=...)`.

- ...:

  Other props (`expandOnClick`, `levelOffset`, ...). See
  <https://mantine.dev/core/tree/>.

## Examples

``` r
if (FALSE) { # \dontrun{
Tree(
  inputId = "tree_click",
  data = list(
    list(value = "src", label = "src", children = list(
      list(value = "src/app.R", label = "app.R")
    )),
    list(value = "readme", label = "README.md")
  )
)
} # }
```
