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
updateMantineSlider <- function(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
) {
  session$sendCustomMessage(
    "shinyMantineUpdateInput",
    list(inputId = session$ns(inputId), value = value)
  )
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
updateMantineRangeSlider <- function(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
) {
  session$sendCustomMessage(
    "shinyMantineUpdateInput",
    list(inputId = session$ns(inputId), value = value)
  )
}

#' Mantine HueSlider (Shiny stateful input, standalone hue channel)
#'
#' The hue-channel slider [ColorPicker()] uses internally, usable on its
#' own if you only need to let the user pick a hue (0-359) — e.g. driving
#' your own custom color composition instead of a full [ColorPicker()].
#'
#' @param inputId Id of the Shiny input; `input[[inputId]]` (0-359) is
#'   synced by dragging.
#' @param value Initial value.
#' @param ... Other props (`size`, ...). See
#'   <https://mantine.dev/core/color-picker/>.
#' @export
HueSlider <- function(inputId, value = 0, ...) {
  mantineElement("HueSlider", inputId = inputId, value = value, ...)
}

#' Mantine AlphaSlider (Shiny stateful input, standalone alpha channel)
#'
#' The alpha-channel slider [ColorPicker()] uses internally, usable on
#' its own — e.g. an opacity control paired with your own color swatch.
#'
#' @param inputId Id of the Shiny input; `input[[inputId]]` (0-1) is
#'   synced by dragging.
#' @param color Base color the alpha gradient is rendered against (e.g.
#'   `"#228be6"` or `"rgba(34, 139, 230, 1)"`).
#' @param value Initial value.
#' @param ... Other props (`size`, ...). See
#'   <https://mantine.dev/core/color-picker/>.
#' @export
AlphaSlider <- function(inputId, color, value = 1, ...) {
  mantineElement("AlphaSlider", inputId = inputId, color = color, value = value, ...)
}

#' Mantine AngleSlider (Shiny stateful input, 0-360 degree dial)
#'
#' A circular dial for picking an angle/direction (0-359 degrees) — e.g.
#' a gradient angle or a compass-style direction picker.
#'
#' @param inputId Id of the Shiny input; `input[[inputId]]` (0-359) is
#'   synced by dragging.
#' @param value Initial value.
#' @param ... Other props (`size`, `marks`, `step`, ...). See
#'   <https://mantine.dev/core/angle-slider/>.
#' @export
AngleSlider <- function(inputId, value = 0, ...) {
  mantineElement("AngleSlider", inputId = inputId, value = value, ...)
}
