#' @include mantine-element.R
NULL

#' Mantine-styled notifications
#'
#' Unlike `shiny::showNotification()` (Bootstrap-styled, clashing with the
#' Mantine theme), these notifications use `@mantine/notifications` — the
#' same library as the components, the same theme/color-scheme.
#'
#' `Notifications()` needs to be mounted **once** in the page (typically
#' inside the main `MantineProvider()`); after that,
#' `showMantineNotification()` can be called from any server-side
#' `observeEvent()`/reactive.
#'
#' @param ... Props for the container (`position`, `zIndex`, `limit`, ...).
#'   See <https://mantine.dev/x/notifications/>.
#' @export
#' @examples
#' \dontrun{
#' # ui:
#' MantineProvider(Notifications(position = "top-right"), ...)
#'
#' # server:
#' observeEvent(input$save_btn, {
#'   showMantineNotification(session, title = "Saved", message = "Changes saved successfully", color = "green")
#' })
#' }
Notifications <- displayComponent("Notifications")

#' Show/hide a Mantine notification
#'
#' @param session Session object passed to the Shiny server function.
#' @param ... Notification props (`title`, `message`, `color`, `icon`,
#'   `autoClose`, `withCloseButton`, `id`, ...). See
#'   <https://mantine.dev/x/notifications/#notifications-system>.
#' @return None. Called for its side effect.
#' @export
showMantineNotification <- function(
  session = shiny::getDefaultReactiveDomain(),
  ...
) {
  session$sendCustomMessage("shinyMantineNotification", list(...))
}

#' @rdname showMantineNotification
#' @param id Id of the notification to hide (the one passed to
#'   `showMantineNotification(id = ...)`).
#' @export
hideMantineNotification <- function(
  session = shiny::getDefaultReactiveDomain(),
  id
) {
  session$sendCustomMessage("shinyMantineHideNotification", id)
}
