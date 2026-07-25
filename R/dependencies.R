#' Mantine JS/CSS dependency
#'
#' HTML dependency that loads the compiled 'shiny.mantine' JavaScript bundle
#' (the 'Mantine' UI components together with its own bundled copy of
#' 'React' 19) and its associated styles.
#'
#' @return An `htmlDependency` object.
#' @export
mantineDependency <- function() {
  htmltools::htmlDependency(
    name = "shiny.mantine",
    version = "0.2.0",
    package = "shiny.mantine",
    src = "www",
    script = "mantine.js"
  )
}
