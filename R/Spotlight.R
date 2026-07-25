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

# Spotlight.Root + compound parts --------------------------------------------
# Lower-level building blocks behind Spotlight(), for grouped actions (via
# SpotlightActionsGroup()) or a fully custom search/empty/footer layout.
# Uses the same global command-palette instance as Spotlight() (opened
# with Cmd/Ctrl+K by default); no store management needed from R.

#' Mantine Spotlight.Root (fully custom Spotlight layout)
#'
#' The lower-level piece behind [Spotlight()], for grouped actions (via
#' [SpotlightActionsGroup()]) or a fully custom search/empty/footer
#' layout that the flat `actions` list of [Spotlight()] doesn't allow.
#'
#' Unlike [Spotlight()], the compound form does **not** filter actions by
#' the search query itself — [SpotlightSearch()] just renders the search
#' box; matching typed text against your [SpotlightAction()]s (and
#' showing/hiding [SpotlightEmpty()] when nothing matches) is up to you,
#' typically via `onQueryChange` + conditionally including
#' [SpotlightEmpty()] only when your own filtering finds nothing. Include
#' it unconditionally and it stays visible alongside real actions, not
#' just when there are none.
#'
#' @param ... Children — typically [SpotlightSearch()],
#'   [SpotlightActionsList()] (wrapping [SpotlightActionsGroup()]s of
#'   [SpotlightAction()]s, and/or [SpotlightEmpty()] — see above), and
#'   [SpotlightFooter()] — plus other props (`shortcut`, `scrollable`,
#'   `maxHeight`, ...). See
#'   <https://mantine.dev/x/spotlight/#compound-components>.
#' @export
#' @examples
#' \dontrun{
#' SpotlightRoot(
#'   SpotlightSearch(placeholder = "Search..."),
#'   SpotlightActionsList(
#'     SpotlightActionsGroup(
#'       label = "Navigation",
#'       SpotlightAction("spotlight_choice", "home", label = "Home"),
#'       SpotlightAction("spotlight_choice", "settings", label = "Settings")
#'     )
#'   )
#' )
#' }
SpotlightRoot <- displayComponent("SpotlightRoot")

#' @rdname SpotlightRoot
#' @export
SpotlightSearch <- displayComponent("SpotlightSearch")

#' @rdname SpotlightRoot
#' @export
SpotlightActionsList <- displayComponent("SpotlightActionsList")

#' @rdname SpotlightRoot
#' @param label Group label.
#' @export
SpotlightActionsGroup <- function(..., label = NULL) {
  mantineElement("SpotlightActionsGroup", label = label, ...)
}

#' @rdname SpotlightRoot
#' @param inputId Id of the Shiny input that receives `value` when this
#'   action is selected.
#' @param value Value sent to `input[[inputId]]` when selected.
#' @param label Action label.
#' @export
SpotlightAction <- function(inputId, value, ..., label = NULL) {
  mantineElement("SpotlightAction", inputId = inputId, value = value, label = label, ...)
}

#' @rdname SpotlightRoot
#' @export
SpotlightEmpty <- displayComponent("SpotlightEmpty")

#' @rdname SpotlightRoot
#' @export
SpotlightFooter <- displayComponent("SpotlightFooter")
