#' @include mantine-element.R
NULL

# Radio / RadioGroup ---------------------------------------------------------

#' Mantine Radio / RadioGroup (Shiny stateful input)
#'
#' `Radio()` must be nested inside `RadioGroup()` — Mantine automatically
#' links each child `Radio()` to the group's state, nothing else needed.
#'
#' @rdname RadioGroup
#' @param inputId Id of the Shiny input; `input[[inputId]]` is synced to
#'   the selection.
#' @param label Group label (for `RadioGroup()`) or the individual
#'   option's label (for `Radio()`).
#' @param value Initial value of the group (for `RadioGroup()`) or the
#'   option's identifier (for `Radio()`).
#' @param ... Other props.
#' @export
RadioGroup <- function(inputId, ..., value = NULL, label = NULL) {
  mantineElement(
    "RadioGroup",
    inputId = inputId,
    value = value,
    label = label,
    ...
  )
}

#' @rdname RadioGroup
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineRadioGroup <- function(
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

#' @rdname RadioGroup
#' @export
Radio <- function(value, label = NULL, ...) {
  mantineElement("Radio", value = value, label = label, ...)
}

# Chip / ChipGroup ------------------------------------------------------------

#' Mantine Chip / ChipGroup (Shiny stateful input)
#'
#' `Chip()` must be nested inside `ChipGroup()` — Mantine automatically
#' links each child `Chip()` to the group's state (single or multiple
#' selection depending on `multiple`).
#'
#' @rdname ChipGroup
#' @param inputId Id of the Shiny input; `input[[inputId]]` is synced to
#'   the selection (a string, or a vector if `multiple = TRUE`).
#' @param value Initial value of the group (for `ChipGroup()`) or the
#'   option's identifier (for `Chip()`).
#' @param multiple If `TRUE`, more than one `Chip()` can be selected at once
#'   and `input[[inputId]]` becomes a character vector.
#' @param ... Other props.
#' @export
ChipGroup <- function(inputId, ..., value = NULL, multiple = FALSE) {
  mantineElement(
    "ChipGroup",
    inputId = inputId,
    value = value,
    multiple = multiple,
    ...
  )
}

#' @rdname ChipGroup
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineChipGroup <- function(
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

#' @rdname ChipGroup
#' @param label Text of the individual Chip.
#' @export
Chip <- function(value, label = NULL, ...) {
  mantineElement("Chip", value = value, ..., label)
}

# Multiple/single value selection inputs -------------------------------------

#' Mantine MultiSelect (Shiny stateful input, multiple selection)
#' @param inputId Id of the Shiny input; `input[[inputId]]` (a character
#'   vector) is synced on every selection.
#' @param label Field label.
#' @param value Initial value (a character vector). Mantine always expects
#'   an array for this component: use `character(0)`/`list()`, not `NULL`,
#'   for "nothing selected" (`NULL` would be serialized as JSON `null`, and
#'   MultiSelect calls `.map()` on its `value` internally).
#' @param ... Other props (`data`, `placeholder`, `searchable`, ...). See
#'   <https://mantine.dev/core/multi-select/>.
#' @export
MultiSelect <- function(inputId, label = NULL, value = list(), ...) {
  mantineElement(
    "MultiSelect",
    inputId = inputId,
    label = label,
    value = ensureArray(value),
    ...
  )
}

#' @rdname MultiSelect
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineMultiSelect <- function(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
) {
  session$sendCustomMessage(
    "shinyMantineUpdateInput",
    list(inputId = session$ns(inputId), value = ensureArray(value))
  )
}

#' Mantine TagsInput (Shiny stateful input, free-form tags)
#' @param inputId Id of the Shiny input; `input[[inputId]]` (a character
#'   vector) is synced on every change.
#' @param label Field label.
#' @param value Initial value (a character vector). As with
#'   [MultiSelect()], use `character(0)`/`list()` for "no tags", not
#'   `NULL`.
#' @param ... Other props (`data`, `placeholder`, ...). See
#'   <https://mantine.dev/core/tags-input/>.
#' @export
TagsInput <- function(inputId, label = NULL, value = list(), ...) {
  mantineElement(
    "TagsInput",
    inputId = inputId,
    label = label,
    value = ensureArray(value),
    ...
  )
}

#' @rdname TagsInput
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineTagsInput <- function(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
) {
  session$sendCustomMessage(
    "shinyMantineUpdateInput",
    list(inputId = session$ns(inputId), value = ensureArray(value))
  )
}

# Other stateful inputs -------------------------------------------------------

#' Mantine Rating (Shiny stateful input)
#' @param inputId Id of the Shiny input; `input[[inputId]]` is synced to
#'   the selection.
#' @param value Initial value.
#' @param ... Other props (`count`, `fractions`, `color`, ...). See
#'   <https://mantine.dev/core/rating/>.
#' @export
Rating <- function(inputId, value = 0, ...) {
  mantineElement("Rating", inputId = inputId, value = value, ...)
}

#' @rdname Rating
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineRating <- function(
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

#' Mantine PinInput (Shiny stateful input, e.g. an OTP code)
#' @param inputId Id of the Shiny input; `input[[inputId]]` is synced on
#'   every digit entered.
#' @param value Initial value.
#' @param ... Other props (`length`, `type`, `mask`, ...). See
#'   <https://mantine.dev/core/pin-input/>.
#' @export
PinInput <- function(inputId, value = "", ...) {
  mantineElement("PinInput", inputId = inputId, value = value, ...)
}

#' @rdname PinInput
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantinePinInput <- function(
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

#' Mantine JsonInput (Shiny stateful input, with JSON validation)
#' @param inputId Id of the Shiny input; `input[[inputId]]` (a string) is
#'   synced on every change.
#' @param label Field label.
#' @param value Initial value.
#' @param ... Other props (`formatOnBlur`, `validationError`, ...). See
#'   <https://mantine.dev/core/json-input/>.
#' @export
JsonInput <- function(inputId, label = NULL, value = "", ...) {
  mantineElement(
    "JsonInput",
    inputId = inputId,
    label = label,
    value = value,
    ...
  )
}

#' @rdname JsonInput
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineJsonInput <- function(
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

#' Mantine ColorInput (Shiny stateful input)
#' @param inputId Id of the Shiny input; `input[[inputId]]` (a color
#'   string) is synced to the selection.
#' @param label Field label.
#' @param value Initial value (e.g. `"#228BE6"`).
#' @param ... Other props (`format`, `swatches`, ...). See
#'   <https://mantine.dev/core/color-input/>.
#' @export
ColorInput <- function(inputId, label = NULL, value = "#000000", ...) {
  mantineElement(
    "ColorInput",
    inputId = inputId,
    label = label,
    value = value,
    ...
  )
}

#' @rdname ColorInput
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineColorInput <- function(
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

#' Mantine ColorPicker (Shiny stateful input, inline picker)
#' @param inputId Id of the Shiny input; `input[[inputId]]` is synced to
#'   the selection.
#' @param value Initial value.
#' @param ... Other props (`format`, `swatches`, ...). See
#'   <https://mantine.dev/core/color-picker/>.
#' @export
ColorPicker <- function(inputId, value = "#000000", ...) {
  mantineElement("ColorPicker", inputId = inputId, value = value, ...)
}

#' @rdname ColorPicker
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineColorPicker <- function(
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

#' Mantine FileInput (file selection, metadata only)
#'
#' `input[[inputId]]` receives `list(count = <n>, files = <list with
#' name/size/type>)` — the file *content* does not travel over this
#' channel (like [Dropzone()]). Always use `$count`, not `length()`.
#'
#' @param inputId Id of the Shiny input receiving file metadata.
#' @param label Field label.
#' @param ... Other props (`multiple`, `accept`, `clearable`, ...). See
#'   <https://mantine.dev/core/file-input/>.
#' @export
FileInput <- function(inputId, label = NULL, ...) {
  mantineElement("FileInput", inputId = inputId, label = label, ...)
}

#' Mantine NativeSelect (Shiny stateful input, native `<select>`)
#' @param inputId Id of the Shiny input; `input[[inputId]]` is synced to
#'   the selection.
#' @param label Field label.
#' @param value Initial value.
#' @param ... Other props (`data`, ...). See
#'   <https://mantine.dev/core/native-select/>.
#' @export
NativeSelect <- function(inputId, label = NULL, value = NULL, ...) {
  mantineElement(
    "NativeSelect",
    inputId = inputId,
    label = label,
    value = value,
    ...
  )
}

#' @rdname NativeSelect
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineNativeSelect <- function(
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

#' Mantine Textarea (Shiny stateful input, multi-line)
#' @param inputId Id of the Shiny input; `input[[inputId]]` is synced on
#'   every keystroke.
#' @param label Field label.
#' @param value Initial value.
#' @param ... Other props (`autosize`, `minRows`, `maxRows`, ...). See
#'   <https://mantine.dev/core/textarea/>.
#' @export
Textarea <- function(inputId, label = NULL, value = "", ...) {
  mantineElement(
    "Textarea",
    inputId = inputId,
    label = label,
    value = value,
    ...
  )
}

#' Mantine Pagination (Shiny stateful input)
#' @param inputId Id of the Shiny input; `input[[inputId]]` is synced on
#'   page change.
#' @param total Total number of pages.
#' @param value Initial page.
#' @param ... Other props (`siblings`, `boundaries`, ...). See
#'   <https://mantine.dev/core/pagination/>.
#' @export
Pagination <- function(inputId, total, value = 1, ...) {
  mantineElement(
    "Pagination",
    inputId = inputId,
    total = total,
    value = value,
    ...
  )
}

#' @rdname Pagination
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantinePagination <- function(
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

#' Mantine Pagination.Root (fully custom pagination layout)
#'
#' The lower-level piece behind [Pagination()], for a fully custom
#' arrangement of the prev/next/first/last controls (reordering them,
#' dropping some, adding your own elements in between) — compose it with
#' [PaginationFirst()], [PaginationPrevious()], [PaginationItems()],
#' [PaginationNext()], [PaginationLast()] and [PaginationDots()], which
#' read the current page from it automatically (no per-part wiring
#' needed). Stateful exactly like [Pagination()]:
#' `input[[inputId]]` is synced on page change, and
#' [updateMantinePagination()] works on it the same way.
#'
#' @param inputId Id of the Shiny input; `input[[inputId]]` is synced on
#'   page change.
#' @param total Total number of pages.
#' @param ... Children (typically [PaginationFirst()],
#'   [PaginationPrevious()], [PaginationItems()], [PaginationNext()],
#'   [PaginationLast()]) and other props (`siblings`, `boundaries`, ...).
#'   See <https://mantine.dev/core/pagination/#compound-components>.
#' @param value Initial page. Must be passed by name (as in the example
#'   below): with children in `...`, an unnamed argument here would bind
#'   to `value` positionally instead of joining the children, since `...`
#'   only captures unnamed arguments that come *after* it.
#' @export
#' @examples
#' \dontrun{
#' Group(
#'   PaginationRoot(
#'     inputId = "page", total = 10,
#'     PaginationFirst(), PaginationPrevious(), PaginationItems(),
#'     PaginationNext(), PaginationLast()
#'   )
#' )
#' }
PaginationRoot <- function(inputId, total, ..., value = 1) {
  mantineElement(
    "PaginationRoot",
    inputId = inputId,
    total = total,
    value = value,
    ...
  )
}

# Accordion -------------------------------------------------------------------

#' Mantine Accordion (Shiny stateful input)
#'
#' `AccordionItem()` (containing `AccordionControl()` + `AccordionPanel()`)
#' must be nested inside `Accordion()`.
#'
#' @rdname Accordion
#' @param inputId Id of the Shiny input; `input[[inputId]]` (a string, or
#'   a vector if `multiple = TRUE`) is synced on open/close.
#' @param value Initial value (an `AccordionItem()`'s `value`, or a vector
#'   if `multiple = TRUE`).
#' @param multiple If `TRUE`, more than one item can be open at once and
#'   `input[[inputId]]` becomes a character vector.
#' @param ... Other props/children.
#' @export
Accordion <- function(inputId, ..., value = NULL, multiple = FALSE) {
  mantineElement(
    "Accordion",
    inputId = inputId,
    value = value,
    multiple = multiple,
    ...
  )
}

#' @rdname Accordion
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineAccordion <- function(
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

#' @rdname Accordion
#' @export
AccordionItem <- displayComponent("Accordion.Item")

#' @rdname Accordion
#' @export
AccordionControl <- displayComponent("Accordion.Control")

#' @rdname Accordion
#' @export
AccordionPanel <- displayComponent("Accordion.Panel")
