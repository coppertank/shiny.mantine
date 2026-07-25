#' @include mantine-element.R
NULL

#' Drag-and-drop reorderable list
#'
#' Uses `@hello-pangea/dnd` internally. After each reorder,
#' `input[[inputId]]` receives the new order as a vector of `value`.
#'
#' @param inputId Id of the Shiny input receiving the new order.
#' @param items List of `list(value = ..., label = ...)`, one per item, in
#'   their initial order.
#' @param withHandle If `TRUE`, dragging only starts from the handle icon;
#'   if `FALSE`, the whole row is draggable.
#' @export
#' @examples
#' \dontrun{
#' SortableList(
#'   "elements",
#'   items = list(
#'     list(value = "H", label = "Hydrogen"),
#'     list(value = "He", label = "Helium")
#'   )
#' )
#' }
SortableList <- function(inputId, items, withHandle = FALSE) {
  mantineElement(
    "SortableList",
    inputId = inputId,
    items = items,
    withHandle = withHandle
  )
}

#' Drag-and-drop reorderable table
#'
#' Uses `@hello-pangea/dnd` internally. After each reorder,
#' `input[[inputId]]` receives the new order as a vector of `value`.
#'
#' @param inputId Id of the Shiny input receiving the new order.
#' @param items List of `list(value = ..., cells = list(...))`, one per
#'   row, in their initial order (`cells` = the values for each column).
#' @param columns Vector of column header labels.
#' @export
#' @examples
#' \dontrun{
#' SortableTable(
#'   "elements",
#'   columns = c("Symbol", "Name"),
#'   items = list(
#'     list(value = "H", cells = list("H", "Hydrogen")),
#'     list(value = "He", cells = list("He", "Helium"))
#'   )
#' )
#' }
SortableTable <- function(inputId, items, columns) {
  mantineElement(
    "SortableTable",
    inputId = inputId,
    items = items,
    columns = columns
  )
}
