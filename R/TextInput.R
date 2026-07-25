#' Mantine TextInput (Shiny stateful input)
#'
#' @param inputId Id of the Shiny input; `input[[inputId]]` is synced on
#'   every keystroke.
#' @param label Field label.
#' @param value Initial value.
#' @param ... Other props (`placeholder`, `description`, `error`,
#'   `disabled`, ...). See <https://mantine.dev/core/text-input/>.
#' @return A `mantine_element` to nest inside [MantineProvider()].
#' @export
TextInput <- function(inputId, label = NULL, value = "", ...) {
  mantineElement("TextInput", inputId = inputId, label = label, value = value, ...)
}

#' @rdname TextInput
#' @param session Session object passed to the Shiny server function.
#' @note The name is `updateMantineTextInput()` (not `updateTextInput()`) to
#'   avoid masking `shiny::updateTextInput()` when both packages are loaded
#'   together.
#' @export
updateMantineTextInput <- function(session = shiny::getDefaultReactiveDomain(), inputId, value = NULL, ...) {
  session$sendCustomMessage("shinyMantineUpdateInput", list(
    inputId = session$ns(inputId),
    value = value
  ))
}
