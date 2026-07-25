#' @include mantine-element.R
NULL

#' Mantine CodeHighlight (code block)
#'
#' No syntax coloring (always uses a "plain text adapter" to avoid
#' bloating the bundle with `highlight.js`/`shiki`): the block still shows
#' with a monospace font, line numbers, a "copy" button, and a language
#' label — just without the colors.
#'
#' @rdname CodeHighlight
#' @param code The code to display (a string).
#' @param language Language (label only, e.g. `"r"`, `"js"`).
#' @param ... Other props (`withCopyButton`, `copyLabel`, ...). See
#'   <https://mantine.dev/x/code-highlight/>.
#' @export
CodeHighlight <- function(code, language = NULL, ...) {
  mantineElement("CodeHighlight", code = code, language = language, ...)
}

#' @rdname CodeHighlight
#' @export
InlineCodeHighlight <- function(code, language = NULL, ...) {
  mantineElement("InlineCodeHighlight", code = code, language = language, ...)
}

#' Mantine CodeHighlightTabs (tabbed multi-file code block)
#'
#' Like [CodeHighlight()] (same plain-text adapter, no syntax coloring), but
#' displays several code snippets as a tabbed file browser.
#' @param code A list of `list(code = ..., language = ..., fileName = ...)`,
#'   one per tab.
#' @param ... Other props (`withCopyButton`, `defaultActiveTab`, ...). See
#'   <https://mantine.dev/x/code-highlight/#codehighlighttabs>.
#' @export
#' @examples
#' \dontrun{
#' CodeHighlightTabs(code = list(
#'   list(fileName = "app.R", language = "r", code = "shiny::runApp()"),
#'   list(fileName = "index.js", language = "js", code = "console.log('hi')")
#' ))
#' }
CodeHighlightTabs <- function(code, ...) {
  mantineElement("CodeHighlightTabs", code = code, ...)
}
