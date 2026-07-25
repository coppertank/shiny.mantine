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
  mantineElement(
    "Modal",
    mantineId = mantineId,
    inputId = inputId,
    opened = opened,
    ...
  )
}

#' Mantine Modal.Root (fully custom modal layout)
#'
#' The lower-level piece behind [Modal()], for full control over the
#' modal's internal layout (e.g. extra controls next to the title, a
#' non-standard body/footer arrangement) — compose it with
#' [ModalOverlay()], [ModalContent()], [ModalHeader()], [ModalTitle()],
#' [ModalCloseButton()] and [ModalBody()]. Opens/closes from R exactly
#' like [Modal()] (`updateMantineProps(session, mantineId, opened =
#' TRUE/FALSE)`), including [ModalStack()] participation if nested inside
#' one — the compound and all-in-one forms are interchangeable from R's
#' point of view.
#'
#' @param mantineId Identifier for [updateMantineProps()].
#' @param ... Children — typically [ModalOverlay()] and [ModalContent()]
#'   (wrapping [ModalHeader()] with [ModalTitle()] +
#'   [ModalCloseButton()], and [ModalBody()]) — plus other props (`size`,
#'   `centered`, `fullScreen`, ...). See
#'   <https://mantine.dev/core/modal/#modalroot>.
#' @param inputId If provided, receives `FALSE` when the user closes it.
#' @param opened Initial state.
#' @export
#' @examples
#' \dontrun{
#' ModalRoot("custom_modal", inputId = "custom_modal_state",
#'   ModalOverlay(),
#'   ModalContent(
#'     ModalHeader(ModalTitle("Custom layout"), ModalCloseButton()),
#'     ModalBody(Text("Modal content"))
#'   )
#' )
#' }
ModalRoot <- function(mantineId, ..., inputId = NULL, opened = FALSE) {
  mantineElement(
    "ModalRoot",
    mantineId = mantineId,
    inputId = inputId,
    opened = opened,
    ...
  )
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
  mantineElement(
    "Drawer",
    mantineId = mantineId,
    inputId = inputId,
    opened = opened,
    ...
  )
}

#' Mantine Drawer.Root (fully custom drawer layout)
#'
#' Same idea as [ModalRoot()], for [Drawer()] instead of [Modal()]:
#' compose it with [DrawerOverlay()], [DrawerContent()], [DrawerHeader()],
#' [DrawerTitle()], [DrawerCloseButton()] and [DrawerBody()]. Opens/closes
#' from R exactly like [Drawer()], including [DrawerStack()] participation.
#'
#' @param mantineId Identifier for [updateMantineProps()].
#' @param ... Children — typically [DrawerOverlay()] and [DrawerContent()]
#'   (wrapping [DrawerHeader()] with [DrawerTitle()] +
#'   [DrawerCloseButton()], and [DrawerBody()]) — plus other props
#'   (`position`, `size`, ...). See
#'   <https://mantine.dev/core/drawer/#drawerroot>.
#' @param inputId If provided, receives `FALSE` when the user closes it.
#' @param opened Initial state.
#' @export
DrawerRoot <- function(mantineId, ..., inputId = NULL, opened = FALSE) {
  mantineElement(
    "DrawerRoot",
    mantineId = mantineId,
    inputId = inputId,
    opened = opened,
    ...
  )
}

#' Mantine Modal.Stack (coordinated stack of Modal()s)
#'
#' A standalone [Modal()] only ever manages its own `opened` boolean, so
#' having more than one open at the same time (e.g. a confirmation modal
#' opening another, more specific one on top) doesn't layer/animate
#' correctly — each mounts its own independent overlay and focus trap,
#' competing rather than coordinating. Wrapping the same [Modal()]s in
#' `ModalStack()` instead delegates them to Mantine's own stack
#' controller, which handles z-index layering, the background-modal scale
#' effect, focus trapping and Escape-key handling between them.
#'
#' Every child [Modal()] keeps working exactly as documented there —
#' `updateMantineProps(session, mantineId, opened = TRUE/FALSE)` still
#' opens/closes it, and `inputId` still receives `FALSE` on user close.
#' Being nested inside a `ModalStack()` is enough to switch a `Modal()` to
#' coordinated stack behavior; no other change is needed on the R side.
#'
#' @param ... [Modal()] children (each needs its own `mantineId`, as
#'   usual), plus an optional `mantineId` of its own: if provided, lets you
#'   close every modal in the stack at once from R with
#'   `updateMantineProps(session, mantineId, closeAll = TRUE)`. See
#'   <https://mantine.dev/core/modal/#stacked-modals>.
#' @export
#' @examples
#' \dontrun{
#' # ui:
#' ModalStack(
#'   mantineId = "delete_stack",
#'   Modal("delete_page", title = "Delete this page?",
#'     Text("This can be undone later from the trash."),
#'     Button("Continue", inputId = "go_to_confirm")
#'   ),
#'   Modal("confirm_delete", title = "Are you really sure?",
#'     Button("Yes, delete", inputId = "confirm_delete_btn", color = "red")
#'   )
#' )
#'
#' # server:
#' observeEvent(input$go_to_confirm, {
#'   updateMantineProps(session, "confirm_delete", opened = TRUE)
#' })
#' observeEvent(input$confirm_delete_btn, {
#'   updateMantineProps(session, "delete_stack", closeAll = TRUE)
#' })
#' }
ModalStack <- displayComponent("ModalStack")

#' Mantine Drawer.Stack (coordinated stack of Drawer()s)
#'
#' Same idea and API as [ModalStack()], for [Drawer()] instead of
#' [Modal()]: wrap several `Drawer()`s that may be open at the same time
#' in `DrawerStack()` so Mantine coordinates z-index, focus trapping and
#' Escape-key handling between them, instead of each managing its
#' `opened` state independently.
#'
#' @param ... [Drawer()] children (each needs its own `mantineId`, as
#'   usual), plus an optional `mantineId` of its own: if provided, lets you
#'   close every drawer in the stack at once from R with
#'   `updateMantineProps(session, mantineId, closeAll = TRUE)`. See
#'   <https://mantine.dev/core/drawer/#stacked-drawers>.
#' @export
DrawerStack <- displayComponent("DrawerStack")

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
  mantineElement(
    "Dialog",
    mantineId = mantineId,
    inputId = inputId,
    opened = opened,
    ...
  )
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
  mantineElement(
    "Popover",
    mantineId = mantineId,
    inputId = inputId,
    opened = opened,
    ...
  )
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
