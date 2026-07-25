#' @include mantine-element.R
NULL

# Components added in the second Mantine coverage pass: real gaps found by
# diffing the package's component registry against every export of
# @mantine/core (see the "Additional components" / "Intentionally out of
# scope" sections in the README for the full methodology and the list of
# intentionally-skipped low-level primitives).

# Card.Section / ActionIcon.Group -------------------------------------------

#' Mantine Card.Section
#'
#' A full-bleed section inside a [Card()] (e.g. an image header that ignores
#' the card's padding) — pass `withBorder = TRUE`/`inheritPadding = TRUE` as
#' needed.
#' @param ... Props and children. See <https://mantine.dev/core/card/#card-section>.
#' @export
CardSection <- displayComponent("Card.Section")

#' Mantine ActionIcon.Group
#'
#' Groups several [ActionIcon()] visually, the same way [ButtonGroup()] does
#' for [Button()].
#' @param ... Props and children. See <https://mantine.dev/core/action-icon/#actionicongroup>.
#' @export
ActionIconGroup <- displayComponent("ActionIcon.Group")

# Menu extensions: submenus, checkbox/radio items, search, context menu -----

#' Mantine Menu submenu (`Menu.Sub`)
#'
#' Nests a submenu inside a [MenuDropdown()] item. `MenuSubItem()` behaves
#' like [menuItem()] (reports `value` to `input[[inputId]]` on click).
#'
#' @rdname MenuSub
#' @param ... Props and children. See <https://mantine.dev/core/menu/#nested-menus>.
#' @export
MenuSub <- displayComponent("Menu.Sub")

#' @rdname MenuSub
#' @export
MenuSubTarget <- displayComponent("Menu.Sub.Target")

#' @rdname MenuSub
#' @export
MenuSubDropdown <- displayComponent("Menu.Sub.Dropdown")

#' @rdname MenuSub
#' @param inputId Id of the Shiny input that receives the selected value.
#' @param value Value sent to Shiny when the item is clicked.
#' @param label Item text.
#' @export
menuSubItem <- function(inputId, value, label, ...) {
  mantineElement("Menu.Sub.Item", label, inputId = inputId, value = value, ...)
}

#' Mantine Menu checkbox/radio items
#'
#' `MenuCheckboxItem()` is an independently-controlled checkbox row inside a
#' dropdown menu (own `checked`/`value` — not exclusive, unlike radio items).
#' `MenuRadioItem()`/`MenuRadioGroup()` behave like [Radio()]/[RadioGroup()]:
#' nest raw `MenuRadioItem()` calls inside a `MenuRadioGroup(inputId, ...)`.
#'
#' @rdname MenuCheckboxItem
#' @param inputId Id of the Shiny input; `input[[inputId]]` is synced to the
#'   checked state (a boolean).
#' @param label Item text.
#' @param value Initial checked state.
#' @param ... Other props.
#' @export
MenuCheckboxItem <- function(inputId, label = NULL, value = FALSE, ...) {
  mantineElement("Menu.CheckboxItem", inputId = inputId, label = label, value = value, ...)
}

#' @rdname MenuCheckboxItem
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineMenuCheckboxItem <- function(session = shiny::getDefaultReactiveDomain(), inputId, value = NULL, ...) {
  session$sendCustomMessage("shinyMantineUpdateInput", list(inputId = session$ns(inputId), value = value))
}

#' @rdname MenuCheckboxItem
#' @export
MenuCheckboxGroup <- displayComponent("Menu.CheckboxGroup")

#' @rdname MenuCheckboxItem
#' @export
MenuRadioGroup <- function(inputId, ..., value = NULL, label = NULL) {
  mantineElement("Menu.RadioGroup", inputId = inputId, value = value, label = label, ...)
}

#' @rdname MenuCheckboxItem
#' @export
updateMantineMenuRadioGroup <- function(session = shiny::getDefaultReactiveDomain(), inputId, value = NULL, ...) {
  session$sendCustomMessage("shinyMantineUpdateInput", list(inputId = session$ns(inputId), value = value))
}

#' @rdname MenuCheckboxItem
#' @export
MenuRadioItem <- function(value, label = NULL, ...) {
  mantineElement("Menu.RadioItem", value = value, label = label, ...)
}

#' Mantine Menu.Search / Menu.ContextMenu
#'
#' `MenuSearch()` renders a search field inside a [MenuDropdown()]. Wrap a
#' target in `MenuContextMenu()` instead of [MenuTarget()] to open the menu
#' on right-click instead of left-click.
#' @rdname MenuSearch
#' @param ... Props and children. See <https://mantine.dev/core/menu/>.
#' @export
MenuSearch <- displayComponent("Menu.Search")

#' @rdname MenuSearch
#' @export
MenuContextMenu <- displayComponent("Menu.ContextMenu")

# Menubar (desktop-app-style menu bar, distinct from the Menu dropdown) -----

#' Mantine Menubar
#'
#' A horizontal bar of menus (File/Edit/View-style), distinct from a single
#' dropdown [Menu()]. `MenubarMenu()` groups one menu's target + dropdown;
#' items inside `MenubarDropdown()` are plain [menuItem()] calls.
#'
#' @rdname Menubar
#' @param ... Props and children. See <https://mantine.dev/core/menubar/>.
#' @export
Menubar <- displayComponent("Menubar")

#' @rdname Menubar
#' @export
MenubarMenu <- displayComponent("Menubar.Menu")

#' @rdname Menubar
#' @export
MenubarTarget <- displayComponent("Menubar.Target")

#' @rdname Menubar
#' @export
MenubarDropdown <- displayComponent("Menubar.Dropdown")

# Splitter --------------------------------------------------------------

#' Mantine Splitter (resizable side-by-side panes)
#'
#' @rdname Splitter
#' @param ... Props and children (usually two or more [SplitterPanel()]).
#'   See <https://mantine.dev/core/splitter/>.
#' @export
Splitter <- displayComponent("Splitter")

#' @rdname Splitter
#' @export
SplitterPanel <- displayComponent("Splitter.Panel")

# Stepper -----------------------------------------------------------------

#' Mantine Stepper (multi-step wizard)
#'
#' Renders a horizontal sequence of steps. The active step is controlled by
#' the app (via `mantineId`/[updateMantineProps()], e.g.
#' `updateMantineProps(session, "wizard", active = 1)`) — Stepper itself
#' does not advance automatically. If `inputId` is set, clicking any step
#' header reports its index (0-based) to `input[[inputId]]`, so the server
#' can decide whether/how to advance.
#'
#' @param mantineId Id used to update `active` reactively from R via
#'   [updateMantineProps()].
#' @param inputId If set, `input[[inputId]]` receives the index of the step
#'   the user clicked.
#' @param active Index (0-based) of the currently active step.
#' @param ... [StepperStep()]/[StepperCompleted()] children, plus other
#'   props (`allowNextStepsSelect`, `color`, ...). See
#'   <https://mantine.dev/core/stepper/>.
#' @export
#' @examples
#' \dontrun{
#' Stepper(
#'   mantineId = "wizard", inputId = "wizard_click", active = 0,
#'   StepperStep(label = "Step 1", description = "Create an account"),
#'   StepperStep(label = "Step 2", description = "Verify email"),
#'   StepperCompleted("All steps completed!")
#' )
#' }
Stepper <- function(mantineId = NULL, inputId = NULL, active = 0, ...) {
  mantineElement("Stepper", mantineId = mantineId, inputId = inputId, active = active, ...)
}

#' @rdname Stepper
#' @export
StepperStep <- displayComponent("Stepper.Step")

#' @rdname Stepper
#' @export
StepperCompleted <- displayComponent("Stepper.Completed")

# Tree / TreeSelect ---------------------------------------------------------

#' Mantine Tree (hierarchical data display)
#'
#' Renders nested/expandable nodes from `data` (a list of
#' `list(value=, label=, children=list(...))`). If `inputId` is set,
#' clicking a node reports its `value` to `input[[inputId]]`.
#'
#' @param inputId If set, `input[[inputId]]` receives the clicked node's
#'   `value`.
#' @param data Tree data: a list of `list(value=, label=, children=...)`.
#' @param ... Other props (`expandOnClick`, `levelOffset`, ...). See
#'   <https://mantine.dev/core/tree/>.
#' @export
#' @examples
#' \dontrun{
#' Tree(
#'   inputId = "tree_click",
#'   data = list(
#'     list(value = "src", label = "src", children = list(
#'       list(value = "src/app.R", label = "app.R")
#'     )),
#'     list(value = "readme", label = "README.md")
#'   )
#' )
#' }
Tree <- function(inputId = NULL, data, ...) {
  mantineElement("Tree", inputId = inputId, data = data, ...)
}

#' Mantine TreeSelect (select input with hierarchical data)
#'
#' Behaves like [Select()]/[MultiSelect()] but for tree-shaped `data`.
#'
#' @param inputId Id of the Shiny input; `input[[inputId]]` is synced to the
#'   selected value(s).
#' @param data Tree data: a list of `list(value=, label=, children=...)`.
#' @param value Initial value: a string, or a character vector if
#'   `multiple = TRUE`.
#' @param ... Other props (`multiple`, `placeholder`, ...). See
#'   <https://mantine.dev/core/tree-select/>.
#' @export
TreeSelect <- function(inputId, data, value = NULL, ...) {
  mantineElement("TreeSelect", inputId = inputId, data = data, value = value, ...)
}

#' @rdname TreeSelect
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineTreeSelect <- function(session = shiny::getDefaultReactiveDomain(), inputId, value = NULL, ...) {
  session$sendCustomMessage("shinyMantineUpdateInput", list(inputId = session$ns(inputId), value = value))
}

# Collapse -------------------------------------------------------------

#' Mantine Collapse (animated show/hide container)
#'
#' Purely controlled by the app: toggle `opened` via
#' `updateMantineProps(session, mantineId, opened = TRUE/FALSE)` (Collapse
#' has no built-in trigger of its own — pair it with a [Button()] whose
#' `observeEvent()` calls `updateMantineProps()`).
#'
#' @param mantineId Id used to control `opened` from R via
#'   [updateMantineProps()].
#' @param opened Whether the content is expanded.
#' @param ... Children and other props (`transitionDuration`, ...). See
#'   <https://mantine.dev/core/collapse/>.
#' @export
#' @examples
#' \dontrun{
#' Collapse(mantineId = "details", opened = FALSE, Text("Hidden content"))
#' # server:
#' observeEvent(input$toggle_btn, {
#'   updateMantineProps(session, "details", opened = !isTRUE(state$open))
#' })
#' }
Collapse <- function(mantineId = NULL, opened = FALSE, ...) {
  mantineElement("Collapse", mantineId = mantineId, opened = opened, ...)
}

# CheckboxGroup / SwitchGroup / CheckboxCard / RadioCard --------------------

#' Mantine CheckboxGroup (multi-selection input, Shiny stateful)
#'
#' `CheckboxGroupItem()` must be used for the children (not the standalone
#' [Checkbox()], which owns its own checked state) — Mantine's group context
#' derives each item's checked state from its `value` against the group's
#' array `value`, the same relationship [RadioGroup()]/[Radio()] and
#' [ChipGroup()]/[Chip()] already have in this package.
#'
#' @rdname CheckboxGroup
#' @param inputId Id of the Shiny input; `input[[inputId]]` (a character
#'   vector) is synced on every change.
#' @param value Initial value (a character vector). Use `character(0)`, not
#'   `NULL`, for "nothing selected".
#' @param label Group label.
#' @param ... [CheckboxGroupItem()] children and other props.
#' @export
CheckboxGroup <- function(inputId, ..., value = list(), label = NULL) {
  mantineElement("CheckboxGroup", inputId = inputId, value = value, label = label, ...)
}

#' @rdname CheckboxGroup
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineCheckboxGroup <- function(session = shiny::getDefaultReactiveDomain(), inputId, value = NULL, ...) {
  session$sendCustomMessage("shinyMantineUpdateInput", list(inputId = session$ns(inputId), value = value))
}

#' @rdname CheckboxGroup
#' @param value The value identifying this checkbox within the group.
#' @export
CheckboxGroupItem <- function(value, label = NULL, ...) {
  mantineElement("CheckboxGroupItem", value = value, label = label, ...)
}

#' Mantine SwitchGroup (multi-selection input, Shiny stateful)
#'
#' Same relationship as [CheckboxGroup()]/[CheckboxGroupItem()], but with
#' `Switch`-styled toggles instead of checkboxes.
#'
#' @rdname SwitchGroup
#' @param inputId Id of the Shiny input; `input[[inputId]]` (a character
#'   vector) is synced on every change.
#' @param value Initial value (a character vector). Use `character(0)`, not
#'   `NULL`, for "nothing selected".
#' @param label Group label.
#' @param ... [SwitchGroupItem()] children and other props.
#' @export
SwitchGroup <- function(inputId, ..., value = list(), label = NULL) {
  mantineElement("SwitchGroup", inputId = inputId, value = value, label = label, ...)
}

#' @rdname SwitchGroup
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineSwitchGroup <- function(session = shiny::getDefaultReactiveDomain(), inputId, value = NULL, ...) {
  session$sendCustomMessage("shinyMantineUpdateInput", list(inputId = session$ns(inputId), value = value))
}

#' @rdname SwitchGroup
#' @param value The value identifying this switch within the group.
#' @export
SwitchGroupItem <- function(value, label = NULL, ...) {
  mantineElement("SwitchGroupItem", value = value, label = label, ...)
}

#' Mantine CheckboxCard / RadioCard (card-styled selectable items)
#'
#' Visually a bordered, clickable card instead of a small checkbox/radio
#' circle. Like [Chip()]/[Radio()], these are raw (unwrapped) so they can be
#' nested inside [CheckboxGroup()]/[RadioGroup()] (Mantine's group context
#' manages their checked state), or composed standalone with your own
#' `checked`/`onClick` via `mantineElement()`.
#'
#' @rdname CheckboxCard
#' @param ... Props and children. See <https://mantine.dev/core/checkbox/#checkboxcard>.
#' @export
CheckboxCard <- displayComponent("CheckboxCard")

#' @rdname CheckboxCard
#' @export
RadioCard <- displayComponent("RadioCard")

# FileButton / MaskInput / DirectionProvider --------------------------------

#' Mantine FileButton (button that opens the native file picker)
#'
#' Like [Dropzone()], only file *metadata* is reported to Shiny —
#' `input[[inputId]]` receives `list(count = <n>, files = <list with
#' name/size/type per file>)`, never the file content. Pair with a real
#' `shiny::fileInput()` if you need the actual upload.
#'
#' @param inputId Id of the Shiny input receiving file metadata.
#' @param label Button text.
#' @param accept MIME types accepted (e.g. `"image/png,image/jpeg"`).
#' @param multiple Whether multiple files can be selected at once.
#' @param ... Other props forwarded to the underlying button (`color`,
#'   `variant`, ...). See <https://mantine.dev/core/file-button/>.
#' @export
FileButton <- function(inputId, label = "Upload file", accept = NULL, multiple = FALSE, ...) {
  mantineElement("FileButton", inputId = inputId, label = label, accept = accept, multiple = multiple, ...)
}

#' Mantine MaskInput (masked text input, e.g. phone numbers)
#'
#' @param inputId Id of the Shiny input; `input[[inputId]]` (the masked
#'   string) is synced on every keystroke.
#' @param mask Mask pattern (e.g. `"+1 (999) 999-9999"`; `9` = digit,
#'   `a`/`A` = lower/uppercase letter, `*` = alphanumeric — see
#'   <https://mantine.dev/core/mask-input/> for the full token list).
#' @param label Field label.
#' @param value Initial value.
#' @param ... Other props (`placeholder`, `description`, ...).
#' @export
MaskInput <- function(inputId, mask, label = NULL, value = "", ...) {
  mantineElement("MaskInput", inputId = inputId, mask = mask, label = label, value = value, ...)
}

#' @rdname MaskInput
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineMaskInput <- function(session = shiny::getDefaultReactiveDomain(), inputId, value = NULL, ...) {
  session$sendCustomMessage("shinyMantineUpdateInput", list(inputId = session$ns(inputId), value = value))
}

#' Mantine DirectionProvider (RTL/LTR text direction)
#'
#' Wrap [MantineProvider()]'s children to set the reading direction for the
#' whole app (`dir = "rtl"` for Arabic/Hebrew, `"ltr"` otherwise).
#' @param dir Either `"ltr"` or `"rtl"`.
#' @param ... Children.
#' @export
DirectionProvider <- function(dir = "ltr", ...) {
  mantineElement("DirectionProvider", dir = dir, ...)
}

# Notification / Transition / Portal / ScrollArea variants / multi-segment
# progress — third coverage pass, closing gaps left open (or not yet
# explicitly documented) after the second pass above. ------------------------

#' Mantine Notification (static notification box)
#'
#' A notification-styled box rendered directly in the page layout — distinct
#' from the toast popups shown by [showMantineNotification()] (the
#' `@mantine/notifications` system), which mount/unmount on their own outside
#' the normal component tree. Use this one when you want a dismissable
#' notification-styled box as part of your regular layout (e.g. inside
#' [renderMantine()]/[mantineOutput()] to show/hide it reactively) instead of
#' a transient popup. `onClose` is not wired to Shiny by default; if you need
#' the built-in close button to do something, pair this with
#' `mantineOutput()`/`renderMantine()` and drive visibility from the server.
#' @param ... Props and children (`title`, `color`, `icon`, `withCloseButton`,
#'   ...). See <https://mantine.dev/core/notification/>.
#' @export
Notification <- displayComponent("Notification")

#' Mantine Transition (mount/unmount animation)
#'
#' Animates its children in and out based on `mounted`. Mantine's own
#' `Transition` takes a render-prop `children` (a function receiving the
#' current transition styles) — incompatible with R's plain,
#' data-only `...` children, so this wraps it internally and applies the
#' styles to a plain wrapper `<div>` around your (static) children instead.
#' @param mounted Whether the children should be visible/mounted.
#' @param ... Props (`transition`, `duration`, `timingFunction`, ...) and the
#'   children to animate. See <https://mantine.dev/core/transition/>.
#' @export
#' @examples
#' \dontrun{
#' Transition(
#'   mounted = input$show, transition = "fade", duration = 200,
#'   Card(withBorder = TRUE, Text("Animated in/out"))
#' )
#' }
Transition <- function(mounted = TRUE, ...) {
  mantineElement("Transition", mounted = mounted, ...)
}

#' Mantine Portal (render children into a different DOM node)
#'
#' @param ... Props and children (`target`, `reuseTargetNode`, ...). See
#'   <https://mantine.dev/core/portal/>.
#' @export
Portal <- displayComponent("Portal")

#' Mantine ScrollAreaAutosize / NativeScrollArea
#'
#' `ScrollAreaAutosize()` is [ScrollArea()] that grows with its content up to
#' `mah` (max height) before scrolling. `NativeScrollArea()` uses the
#' browser's native scrollbars instead of Mantine's custom-styled ones.
#' @rdname ScrollAreaAutosize
#' @param ... Props and children. See <https://mantine.dev/core/scroll-area/>.
#' @export
ScrollAreaAutosize <- displayComponent("ScrollAreaAutosize")

#' @rdname ScrollAreaAutosize
#' @export
NativeScrollArea <- displayComponent("NativeScrollArea")

#' Mantine multi-segment Progress (`Progress.Root`/`.Section`/`.Label`)
#'
#' The compound form of [Progress()], for a single bar split into multiple
#' colored segments (e.g. a stacked disk-usage bar) — nest one
#' `ProgressSection()` per segment (each with its own `value`/`color`)
#' inside `ProgressRoot()`; `ProgressLabel()` renders text inside a section.
#' @rdname ProgressRoot
#' @param ... Props and children. See
#'   <https://mantine.dev/core/progress/#multiple-sections>.
#' @export
#' @examples
#' \dontrun{
#' ProgressRoot(
#'   size = "xl",
#'   ProgressSection(value = 35, color = "blue"),
#'   ProgressSection(value = 20, color = "orange"),
#'   ProgressSection(value = 15, color = "red")
#' )
#' }
ProgressRoot <- displayComponent("Progress.Root")

#' @rdname ProgressRoot
#' @export
ProgressSection <- displayComponent("Progress.Section")

#' @rdname ProgressRoot
#' @export
ProgressLabel <- displayComponent("Progress.Label")
