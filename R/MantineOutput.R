#' Reactive Mantine output
#'
#' Analogous to `shiny::uiOutput()` but for a Mantine sub-tree: the content
#' is reactively recomputed server-side with [renderMantine()], without
#' needing to rebuild the whole page (unlike `MantineProvider()`, which
#' mounts statically once at page load). Fills the architectural gap of not
#' having a `renderUI()`/`reactOutput()` equivalent for Mantine.
#'
#' Each `mantineOutput()` mounts its own independent React root (like every
#' `MantineProvider()`): if you want Mantine's theme/color-scheme inside the
#' output, wrap the content in a `MantineProvider()` inside the expression
#' passed to [renderMantine()]. Every time the expression is re-evaluated,
#' the whole sub-tree is re-rendered: local component state inside it (e.g.
#' text typed into a `TextInput` not controlled by a stable `inputId`) can
#' be lost, exactly as with `renderUI()`.
#'
#' @param outputId Id of the Shiny output.
#' @return A `shiny.tag` to insert into the UI.
#' @export
#' @examples
#' \dontrun{
#' # ui:
#' mantineOutput("my_output")
#'
#' # server:
#' output$my_output <- renderMantine({
#'   MantineProvider(
#'     Card(withBorder = TRUE, Text(paste("Updated at", Sys.time())))
#'   )
#' })
#' }
mantineOutput <- function(outputId) {
  htmltools::tagList(
    mantineDependency(),
    htmltools::div(id = outputId, class = "shiny-mantine-output")
  )
}

#' @rdname mantineOutput
#' @param expr Expression that returns a `shiny.mantine` component (or a
#'   value/tag to render as a child).
#' @param env Environment in which to evaluate `expr`.
#' @param quoted Is `expr` already quoted?
#' @export
renderMantine <- function(expr, env = parent.frame(), quoted = FALSE) {
  func <- shiny::exprToFunction(expr, env, quoted)
  # If the expression calls MantineProvider() (the common case, to get
  # theme/color-scheme inside the output too), toMantineData() automatically
  # extracts its underlying raw element instead of serializing it as static
  # HTML (see the comment in mantine-element.R).
  function() {
    toMantineData(func())
  }
}
