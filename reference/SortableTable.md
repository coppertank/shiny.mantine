# Drag-and-drop reorderable table

Uses `@hello-pangea/dnd` internally. After each reorder,
`input[[inputId]]` receives the new order as a vector of `value`.

## Usage

``` r
SortableTable(inputId, items, columns)
```

## Arguments

- inputId:

  Id of the Shiny input receiving the new order.

- items:

  List of `list(value = ..., cells = list(...))`, one per row, in their
  initial order (`cells` = the values for each column).

- columns:

  Vector of column header labels.

## Examples

``` r
if (FALSE) { # \dontrun{
SortableTable(
  "elements",
  columns = c("Symbol", "Name"),
  items = list(
    list(value = "H", cells = list("H", "Hydrogen")),
    list(value = "He", cells = list("He", "Helium"))
  )
)
} # }
```
