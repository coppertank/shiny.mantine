#' Mantine Button (stateless / action button)
#'
#' Every click increments `input[[inputId]]`, exactly like
#' `shiny::actionButton()`: use it with `observeEvent(input[[inputId]], ...)`.
#' The button keeps no synced local value (unlike [TextInput()]) — it only
#' reports a click counter — which is why there is no `updateButton()`.
#'
#' @param label Button label (text or nested content).
#' @param inputId Id of the Shiny input incremented on every click.
#' @param ... Other props forwarded to Mantine's `Button` component
#'   (`variant`, `color`, `size`, `leftSection`, `disabled`, ...). See
#'   <https://mantine.dev/core/button/>.
#' @export
Button <- function(label, inputId, ...) {
  mantineElement("Button", label, inputId = inputId, ...)
}
