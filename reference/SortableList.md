# Drag-and-drop reorderable list

Uses `@hello-pangea/dnd` internally. After each reorder,
`input[[inputId]]` receives the new order as a vector of `value`.

## Usage

``` r
SortableList(inputId, items, withHandle = FALSE)
```

## Arguments

- inputId:

  Id of the Shiny input receiving the new order.

- items:

  List of `list(value = ..., label = ...)`, one per item, in their
  initial order.

- withHandle:

  If `TRUE`, dragging only starts from the handle icon; if `FALSE`, the
  whole row is draggable.

## Examples

``` r
if (FALSE) { # \dontrun{
SortableList(
  "elements",
  items = list(
    list(value = "H", label = "Hydrogen"),
    list(value = "He", label = "Helium")
  )
)
} # }
```
