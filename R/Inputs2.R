#' @include mantine-element.R
NULL

# Other Shiny stateful inputs (same pattern as TextInput()/Select()) -------

#' Mantine Checkbox (Shiny stateful boolean input)
#' @param inputId Id of the Shiny input; `input[[inputId]]` (`TRUE`/`FALSE`)
#'   is synced on every toggle.
#' @param label Field label.
#' @param value Initial value.
#' @param ... Other props (`description`, `color`, `size`, ...). See
#'   <https://mantine.dev/core/checkbox/>.
#' @export
Checkbox <- function(inputId, label = NULL, value = FALSE, ...) {
  mantineElement("Checkbox", inputId = inputId, label = label, value = value, ...)
}

#' @rdname Checkbox
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineCheckbox <- function(session = shiny::getDefaultReactiveDomain(), inputId, value = NULL, ...) {
  session$sendCustomMessage("shinyMantineUpdateInput", list(inputId = session$ns(inputId), value = value))
}

#' Mantine Autocomplete (Shiny stateful input)
#' @param inputId Id of the Shiny input; `input[[inputId]]` is synced on
#'   every keystroke/selection.
#' @param label Field label.
#' @param value Initial value.
#' @param ... Other props (`data`, `placeholder`, `limit`, ...). See
#'   <https://mantine.dev/core/autocomplete/>.
#' @export
Autocomplete <- function(inputId, label = NULL, value = "", ...) {
  mantineElement("Autocomplete", inputId = inputId, label = label, value = value, ...)
}

#' @rdname Autocomplete
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineAutocomplete <- function(session = shiny::getDefaultReactiveDomain(), inputId, value = NULL, ...) {
  session$sendCustomMessage("shinyMantineUpdateInput", list(inputId = session$ns(inputId), value = value))
}

#' Mantine NumberInput (Shiny stateful input)
#' @param inputId Id of the Shiny input; `input[[inputId]]` is synced on
#'   every change.
#' @param label Field label.
#' @param value Initial value (a number or `NULL`).
#' @param ... Other props (`min`, `max`, `step`, `prefix`, `suffix`, ...).
#'   See <https://mantine.dev/core/number-input/>.
#' @export
NumberInput <- function(inputId, label = NULL, value = NULL, ...) {
  mantineElement("NumberInput", inputId = inputId, label = label, value = value, ...)
}

#' @rdname NumberInput
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineNumberInput <- function(session = shiny::getDefaultReactiveDomain(), inputId, value = NULL, ...) {
  session$sendCustomMessage("shinyMantineUpdateInput", list(inputId = session$ns(inputId), value = value))
}

#' Mantine PasswordInput (Shiny stateful input)
#' @param inputId Id of the Shiny input; `input[[inputId]]` is synced on
#'   every keystroke.
#' @param label Field label.
#' @param value Initial value.
#' @param ... Other props (`placeholder`, `description`, ...). See
#'   <https://mantine.dev/core/password-input/>.
#' @export
PasswordInput <- function(inputId, label = NULL, value = "", ...) {
  mantineElement("PasswordInput", inputId = inputId, label = label, value = value, ...)
}

#' @rdname PasswordInput
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantinePasswordInput <- function(session = shiny::getDefaultReactiveDomain(), inputId, value = NULL, ...) {
  session$sendCustomMessage("shinyMantineUpdateInput", list(inputId = session$ns(inputId), value = value))
}

#' Mantine SegmentedControl (Shiny stateful input)
#' @param inputId Id of the Shiny input; `input[[inputId]]` is synced on
#'   every selection.
#' @param data Vector or list of options (`value`/`label`). See
#'   <https://mantine.dev/core/segmented-control/>.
#' @param value Initial value.
#' @param ... Other props (`color`, `fullWidth`, ...).
#' @export
SegmentedControl <- function(inputId, data, value = NULL, ...) {
  mantineElement("SegmentedControl", inputId = inputId, data = data, value = value, ...)
}

#' @rdname SegmentedControl
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineSegmentedControl <- function(session = shiny::getDefaultReactiveDomain(), inputId, value = NULL, ...) {
  session$sendCustomMessage("shinyMantineUpdateInput", list(inputId = session$ns(inputId), value = value))
}

# Display-only components ------------------------------------------------

#' Mantine RingProgress
#' @param ... Props (`sections`, `label`, `size`, `thickness`, ...). See
#'   <https://mantine.dev/core/ring-progress/>.
#' @export
RingProgress <- displayComponent("RingProgress")

#' Mantine Image
#' @param ... Props (`src`, `radius`, `fit`, `h`, ...). See
#'   <https://mantine.dev/core/image/>.
#' @export
Image <- displayComponent("Image")

#' Mantine Tooltip
#' @param ... Props and a single child (`label`, `position`, `withArrow`,
#'   ...). See <https://mantine.dev/core/tooltip/>.
#' @export
Tooltip <- displayComponent("Tooltip")
