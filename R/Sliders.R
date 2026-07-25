#' @include mantine-element.R
NULL

#' Mantine Slider (Shiny stateful input)
#' @param inputId Id of the Shiny input; `input[[inputId]]` is synced by
#'   dragging the handle.
#' @param value Initial value.
#' @param ... Other props (`min`, `max`, `step`, `marks`, `label`, `color`,
#'   ...). See <https://mantine.dev/core/slider/>.
#' @export
Slider <- function(inputId, value = 0, ...) {
  mantineElement("Slider", inputId = inputId, value = value, ...)
}

#' @rdname Slider
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineSlider <- function(session = shiny::getDefaultReactiveDomain(), inputId, value = NULL, ...) {
  session$sendCustomMessage("shinyMantineUpdateInput", list(inputId = session$ns(inputId), value = value))
}

#' Mantine RangeSlider (Shiny stateful input, range)
#' @param inputId Id of the Shiny input; `input[[inputId]]` (a vector of 2
#'   numbers) is synced by dragging the handles.
#' @param value Initial value, a vector of 2 numbers (e.g. `c(20, 80)`).
#' @param ... Other props (`min`, `max`, `step`, `marks`, ...). See
#'   <https://mantine.dev/core/slider/#rangeslider>.
#' @export
RangeSlider <- function(inputId, value = c(20, 80), ...) {
  mantineElement("RangeSlider", inputId = inputId, value = value, ...)
}

#' @rdname RangeSlider
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineRangeSlider <- function(session = shiny::getDefaultReactiveDomain(), inputId, value = NULL, ...) {
  session$sendCustomMessage("shinyMantineUpdateInput", list(inputId = session$ns(inputId), value = value))
}
