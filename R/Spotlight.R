#' @include mantine-element.R
NULL

#' Mantine Spotlight (command palette, Cmd/Ctrl+K by default)
#'
#' Selecting an action sends its `id` to `input[[inputId]]`.
#'
#' @param inputId Id of the Shiny input that receives the selected
#'   action's `id`.
#' @param actions List of actions: each a `list(id = ..., label = ...,
#'   description = ...)`.
#' @param ... Other props (`shortcut`, `nothingFound`, `limit`, ...). See
#'   <https://mantine.dev/x/spotlight/>.
#' @export
#' @examples
#' \dontrun{
#' Spotlight(
#'   inputId = "spotlight_action",
#'   actions = list(
#'     list(id = "home", label = "Go to Home", description = "Main page"),
#'     list(id = "settings", label = "Go to Settings")
#'   )
#' )
#' }
Spotlight <- function(inputId, actions, ...) {
  mantineElement("Spotlight", inputId = inputId, actions = actions, ...)
}
