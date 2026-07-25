#' Mantine Switch (Shiny stateful boolean input)
#'
#' @param inputId Id of the Shiny input; `input[[inputId]]` (`TRUE`/`FALSE`)
#'   is synced on every toggle.
#' @param label Field label.
#' @param value Initial value.
#' @param ... Other props (`description`, `color`, `size`, `disabled`, ...).
#'   See <https://mantine.dev/core/switch/>.
#' @export
Switch <- function(inputId, label = NULL, value = FALSE, ...) {
  mantineElement("Switch", inputId = inputId, label = label, value = value, ...)
}

#' @rdname Switch
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineSwitch <- function(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
) {
  session$sendCustomMessage(
    "shinyMantineUpdateInput",
    list(
      inputId = session$ns(inputId),
      value = value
    )
  )
}
