#' @include mantine-element.R
NULL

#' Mantine Table family
#'
#' For a table with search/sort or selection, compose these elements by
#' hand (see `inst/examples/tables-app.R`); for a drag-and-drop reorderable
#' table use [SortableTable()].
#'
#' @rdname Table
#' @param ... Props and children. See <https://mantine.dev/core/table/>.
#' @export
Table <- displayComponent("Table")

#' @rdname Table
#' @export
TableThead <- displayComponent("Table.Thead")

#' @rdname Table
#' @export
TableTbody <- displayComponent("Table.Tbody")

#' @rdname Table
#' @export
TableTfoot <- displayComponent("Table.Tfoot")

#' @rdname Table
#' @export
TableTr <- displayComponent("Table.Tr")

#' @rdname Table
#' @export
TableTh <- displayComponent("Table.Th")

#' @rdname Table
#' @export
TableTd <- displayComponent("Table.Td")

#' @rdname Table
#' @export
TableCaption <- displayComponent("Table.Caption")

#' @rdname Table
#' @export
TableScrollContainer <- displayComponent("Table.ScrollContainer")

#' Table with search, sort, and/or selection (client-side)
#'
#' Every time the visible or selected rows change, `input[[inputId]]`
#' receives `list(visible = ..., selected = ...)` (vectors of the rows'
#' `value`). For a simple table without these features, compose
#' [Table()]/[TableThead()]/[TableTr()]/... by hand (see
#' `inst/examples/tables-app.R`).
#'
#' @param inputId Id of the Shiny input receiving visible/selected rows.
#' @param data List of rows: each row is a `list()` with a `value` field
#'   (unique id) plus one field per column.
#' @param columns List of `list(key = ..., label = ...)`, one per column
#'   (`key` must match the field names in `data`).
#' @param selectable If `TRUE`, adds a checkbox column (+ "select all").
#' @param searchable If `TRUE`, adds a search bar that filters the rows.
#' @param sortable If `TRUE`, clicking a header sorts the table by that
#'   column.
#' @export
#' @examples
#' \dontrun{
#' DataTable(
#'   "table",
#'   data = list(
#'     list(value = 1, name = "Ada", role = "Dev"),
#'     list(value = 2, name = "Maria", role = "Design")
#'   ),
#'   columns = list(list(key = "name", label = "Name"), list(key = "role", label = "Role")),
#'   searchable = TRUE, sortable = TRUE, selectable = TRUE
#' )
#' }
DataTable <- function(inputId, data, columns, selectable = FALSE, searchable = FALSE, sortable = FALSE) {
  mantineElement(
    "DataTable",
    inputId = inputId, data = data, columns = columns,
    selectable = selectable, searchable = searchable, sortable = sortable
  )
}
