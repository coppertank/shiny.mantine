#' @include mantine-element.R
NULL

# Modal / Drawer / Dialog / Popover: openable/closable both from R --------
# (via updateMantineProps(session, mantineId, opened = TRUE/FALSE)) and by
# the user (X, click outside, Escape) — solves the architectural gap of
# "no way to control an overlay's open state from R".

#' Mantine Modal
#'
#' Open/close from R with
#' `updateMantineProps(session, mantineId, opened = TRUE/FALSE)`. When the
#' user closes it (X, click outside, Escape), `input[[inputId]]` (if
#' provided) receives `FALSE`.
#'
#' @param mantineId Identifier for [updateMantineProps()] (opening/closing
#'   from R). Required: without it, the Modal cannot be controlled from R
#'   (it would stay in its initial `opened` state).
#' @param ... Children (the modal's content) and other props (`title`,
#'   `size`, `centered`, ...). See <https://mantine.dev/core/modal/>.
#' @param inputId If provided, receives `FALSE` when the user closes the
#'   modal.
#' @param opened Initial state (usually `FALSE`: opened from R at the
#'   right moment with `updateMantineProps()`).
#' @export
#' @examples
#' \dontrun{
#' # ui:
#' Modal("confirm_modal", inputId = "confirm_modal_state", title = "Confirm",
#'   Text("Are you sure?"),
#'   Button("Confirm", inputId = "confirm_btn")
#' )
#' Button("Open modal", inputId = "open_modal_btn")
#'
#' # server:
#' observeEvent(input$open_modal_btn, {
#'   updateMantineProps(session, "confirm_modal", opened = TRUE)
#' })
#' observeEvent(input$confirm_btn, {
#'   updateMantineProps(session, "confirm_modal", opened = FALSE)
#' })
#' }
Modal <- function(mantineId, ..., inputId = NULL, opened = FALSE) {
  mantineElement("Modal", mantineId = mantineId, inputId = inputId, opened = opened, ...)
}

#' Mantine Drawer (like Modal, but slides in from a screen edge)
#'
#' Same pattern as [Modal()]: open/close from R with
#' `updateMantineProps(session, mantineId, opened = TRUE/FALSE)`.
#'
#' @param mantineId Identifier for [updateMantineProps()].
#' @param ... Children and other props (`position`, `size`, `title`, ...).
#'   See <https://mantine.dev/core/drawer/>.
#' @param inputId If provided, receives `FALSE` on user close.
#' @param opened Initial state.
#' @export
Drawer <- function(mantineId, ..., inputId = NULL, opened = FALSE) {
  mantineElement("Drawer", mantineId = mantineId, inputId = inputId, opened = opened, ...)
}

#' Mantine Dialog (small non-modal overlay, screen corner)
#'
#' Same pattern as [Modal()]: open/close from R with
#' `updateMantineProps(session, mantineId, opened = TRUE/FALSE)`.
#'
#' @param mantineId Identifier for [updateMantineProps()].
#' @param ... Children and other props (`position`, `size`, ...). See
#'   <https://mantine.dev/core/dialog/>.
#' @param inputId If provided, receives `FALSE` on user close.
#' @param opened Initial state.
#' @export
Dialog <- function(mantineId, ..., inputId = NULL, opened = FALSE) {
  mantineElement("Dialog", mantineId = mantineId, inputId = inputId, opened = opened, ...)
}

#' Mantine Popover (controlled) and primitives
#'
#' For a self-managed client-side dropdown (no control from R needed) use
#' [HoverCard()]/[Menu()]. Use `Popover()` with `mantineId` only if you
#' need to explicitly open/close it from R.
#'
#' @rdname Popover
#' @param mantineId Identifier for [updateMantineProps()].
#' @param ... Children (usually [PopoverTarget()] + [PopoverDropdown()])
#'   and other props. See <https://mantine.dev/core/popover/>.
#' @param inputId If provided, receives `FALSE` on user close.
#' @param opened Initial state.
#' @export
Popover <- function(mantineId, ..., inputId = NULL, opened = FALSE) {
  mantineElement("Popover", mantineId = mantineId, inputId = inputId, opened = opened, ...)
}

#' @rdname Popover
#' @export
PopoverTarget <- displayComponent("Popover.Target")

#' @rdname Popover
#' @export
PopoverDropdown <- displayComponent("Popover.Dropdown")

#' Mantine Affix (fixed-position content, e.g. a "back to top" button)
#' @param ... Props (`position = list(bottom = 20, right = 20)`, ...) and
#'   children. See <https://mantine.dev/core/affix/>.
#' @export
Affix <- displayComponent("Affix")

#' Mantine LoadingOverlay
#'
#' @param visible If `TRUE`, shows the loading overlay. Pass `mantineId`
#'   among the `...` to be able to toggle it from R with
#'   [updateMantineProps()].
#' @param ... Other props (`overlayProps`, `loaderProps`, ...). See
#'   <https://mantine.dev/core/loading-overlay/>.
#' @export
LoadingOverlay <- function(visible = FALSE, ...) {
  mantineElement("LoadingOverlay", visible = visible, ...)
}
