# Table with search, sort, and/or selection (client-side)

Every time the visible or selected rows change, `input[[inputId]]`
receives `list(visible = ..., selected = ...)` (vectors of the rows'
`value`). For a simple table without these features, compose
[`Table()`](https://coppertank.github.io/shiny.mantine/reference/Table.md)/[`TableThead()`](https://coppertank.github.io/shiny.mantine/reference/Table.md)/[`TableTr()`](https://coppertank.github.io/shiny.mantine/reference/Table.md)/...
by hand (see `inst/examples/tables-app.R`).

## Usage

``` r
DataTable(
  inputId,
  data,
  columns,
  selectable = FALSE,
  searchable = FALSE,
  sortable = FALSE
)
```

## Arguments

- inputId:

  Id of the Shiny input receiving visible/selected rows.

- data:

  List of rows: each row is a
  [`list()`](https://rdrr.io/r/base/list.html) with a `value` field
  (unique id) plus one field per column.

- columns:

  List of `list(key = ..., label = ...)`, one per column (`key` must
  match the field names in `data`).

- selectable:

  If `TRUE`, adds a checkbox column (+ "select all").

- searchable:

  If `TRUE`, adds a search bar that filters the rows.

- sortable:

  If `TRUE`, clicking a header sorts the table by that column.

## Examples

``` r
if (FALSE) { # \dontrun{
DataTable(
  "table",
  data = list(
    list(value = 1, name = "Ada", role = "Dev"),
    list(value = 2, name = "Maria", role = "Design")
  ),
  columns = list(list(key = "name", label = "Name"), list(key = "role", label = "Role")),
  searchable = TRUE, sortable = TRUE, selectable = TRUE
)
} # }
```
