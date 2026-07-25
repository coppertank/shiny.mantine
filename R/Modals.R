#' @include mantine-element.R
NULL

#' Imperative modals (`@mantine/modals`)
#'
#' Imperative API to open modals (confirmation or generic) from a single
#' server-side call, without having to declare a [Modal()] in the UI ahead
#' of time. Only supports simple props (no nested Mantine component trees:
#' for a modal with rich Mantine content, compose [Modal()] with
#' [updateMantineProps()] instead).
#'
#' Requires `ModalsProvider()` mounted **once** in the page, wrapping the
#' content (like `MantineProvider()`).
#'
#' @param ... Children and props (`ModalsProvider()`); see
#'   <https://mantine.dev/x/modals/>.
#' @export
#' @examples
#' \dontrun{
#' # ui:
#' MantineProvider(ModalsProvider(...))
#'
#' # server:
#' observeEvent(input$delete_btn, {
#'   openMantineConfirmModal(
#'     session, inputId = "confirm_delete",
#'     title = "Confirm deletion",
#'     children = "This action cannot be undone. Continue?",
#'     labels = list(confirm = "Delete", cancel = "Cancel"),
#'     confirmProps = list(color = "red")
#'   )
#' })
#' observeEvent(input$confirm_delete, {
#'   if (isTRUE(input$confirm_delete)) {
#'     # ... actually delete ...
#'   }
#' })
#' }
ModalsProvider <- displayComponent("ModalsProvider")

#' Open a confirmation modal (`@mantine/modals`)
#'
#' On confirm, `input[[inputId]]` receives `TRUE`; on cancel, `FALSE`.
#'
#' @param session Session object passed to the Shiny server function.
#' @param inputId Id of the Shiny input that receives `TRUE`/`FALSE`.
#' @param ... Other props (`title`, `children` as plain text (the body
#'   message), `labels`, `confirmProps`, `cancelProps`, ...).
#' @export
openMantineConfirmModal <- function(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  ...
) {
  session$sendCustomMessage(
    "shinyMantineOpenConfirmModal",
    c(
      list(inputId = session$ns(inputId)),
      list(...)
    )
  )
}

#' Open a generic modal (`@mantine/modals`)
#' @param session Session object passed to the Shiny server function.
#' @param ... Props (`title`, `children` as plain text, `size`, ...).
#' @export
openMantineModal <- function(session = shiny::getDefaultReactiveDomain(), ...) {
  session$sendCustomMessage("shinyMantineOpenModal", list(...))
}

#' Close an imperatively-opened modal (`@mantine/modals`)
#' @param session Session object passed to the Shiny server function.
#' @param id Id of the modal (the one returned/assigned when it was opened).
#' @export
closeMantineModal <- function(session = shiny::getDefaultReactiveDomain(), id) {
  session$sendCustomMessage("shinyMantineCloseModal", id)
}

#' Close all imperatively-opened modals (`@mantine/modals`)
#' @param session Session object passed to the Shiny server function.
#' @export
closeAllMantineModals <- function(session = shiny::getDefaultReactiveDomain()) {
  session$sendCustomMessage("shinyMantineCloseAllModals", list())
}
