#' Page navigation inside an AppShell (client-side router)
#'
#' `Pages()` keeps the "active page" state entirely on the client: every
#' [navLinkItem()] nested in the same hierarchy, when clicked, instantly
#' switches which `Page()` child is visible — without rebuilding the whole
#' React tree and without needing a round-trip to the server (unlike a
#' reactive `renderUI()`). The click is still sent to Shiny via the link's
#' `inputId`, so you can also react server-side if needed (analytics,
#' side effects, ...).
#'
#' The whole [AppShell()] is typically nested inside `Pages()`, so both the
#' Navbar (with the `navLinkItem()`s) and the Main (with the `Page()`s)
#' share the same navigation state.
#'
#' @param active Initial value of the active page (must match the `value`
#'   — or `pageValue` — of one of the [navLinkItem()]s, and the `value` of
#'   one of the child `Page()`s).
#' @param ... Content, typically a whole [AppShell()].
#' @export
#' @examples
#' \dontrun{
#' Pages(
#'   active = "home",
#'   AppShell(
#'     AppShellNavbar(
#'       navLinkItem("navId", "home", "Home"),
#'       navLinkItem("navId", "settings", "Settings")
#'     ),
#'     AppShellMain(
#'       Page(value = "home", Text("Welcome")),
#'       Page(value = "settings", Text("Settings"))
#'     )
#'   )
#' )
#' }
Pages <- function(active = NULL, ...) {
  mantineElement("Pages", active = active, ...)
}

#' @rdname Pages
#' @param value Page identifier; must match the `value` (or `pageValue`)
#'   sent by a [navLinkItem()] to be selected.
#' @export
Page <- function(value, ...) {
  mantineElement("Page", value = value, ...)
}
