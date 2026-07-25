#' @include mantine-element.R
NULL

#' Mantine NavigationProgress (progress bar at the top of the page)
#'
#' Should be inserted once in the UI (typically inside `MantineProvider()`,
#' the same way as `Notifications()`); it is then driven from the server
#' with the imperative functions `startMantineProgress()`,
#' `setMantineProgress()`, `incrementMantineProgress()`,
#' `decrementMantineProgress()`, `completeMantineProgress()`, and
#' `resetMantineProgress()`.
#'
#' @rdname NavigationProgress
#' @param ... Optional props (`color`, `size`, `zIndex`, ...). See
#'   <https://mantine.dev/x/nprogress/>.
#' @export
#' @examples
#' \dontrun{
#' # ui:
#' MantineProvider(NavigationProgress(), ...)
#'
#' # server:
#' observeEvent(input$go, {
#'   startMantineProgress(session)
#'   ...
#'   completeMantineProgress(session)
#' })
#' }
NavigationProgress <- function(...) {
  mantineElement("NavigationProgress", ...)
}

#' @keywords internal
sendMantineProgress <- function(session, action, value = NULL) {
  session$sendCustomMessage("shinyMantineProgress", list(action = action, value = value))
}

#' @rdname NavigationProgress
#' @param session Shiny session.
#' @export
startMantineProgress <- function(session = shiny::getDefaultReactiveDomain()) {
  sendMantineProgress(session, "start")
}

#' @rdname NavigationProgress
#' @param value Percentage value (0-100).
#' @export
setMantineProgress <- function(value, session = shiny::getDefaultReactiveDomain()) {
  sendMantineProgress(session, "set", value)
}

#' @rdname NavigationProgress
#' @export
incrementMantineProgress <- function(value = NULL, session = shiny::getDefaultReactiveDomain()) {
  sendMantineProgress(session, "increment", value)
}

#' @rdname NavigationProgress
#' @export
decrementMantineProgress <- function(value = NULL, session = shiny::getDefaultReactiveDomain()) {
  sendMantineProgress(session, "decrement", value)
}

#' @rdname NavigationProgress
#' @export
completeMantineProgress <- function(session = shiny::getDefaultReactiveDomain()) {
  sendMantineProgress(session, "complete")
}

#' @rdname NavigationProgress
#' @export
resetMantineProgress <- function(session = shiny::getDefaultReactiveDomain()) {
  sendMantineProgress(session, "reset")
}
