#' @include mantine-element.R
NULL

# Combobox: Mantine's headless building block for fully custom
# select/autocomplete/multiselect components (Select()/MultiSelect()/
# Autocomplete()/TagsInput()/PillsInput() are all built on top of it
# internally). The real component requires a live `useCombobox()` store (a
# JS object with methods, e.g. `combobox.toggleDropdown()`) passed as its
# `store` prop - unlike every other prop in this package, that store cannot
# be expressed as JSON and cross the R/JS bridge. The JS side (see
# ShinyCombobox in js/src/index.js) creates and owns that store
# internally, so the R API below stays fully declarative.

#' Mantine Combobox family (headless dropdown primitive for custom selects)
#'
#' `Combobox()` is Mantine's low-level building block for custom
#' select/autocomplete/multiselect UIs — the same primitive
#' [Select()]/[MultiSelect()]/[Autocomplete()]/[TagsInput()]/[PillsInput()]
#' are built on top of internally. Reach for it only when those don't fit
#' (e.g. options need custom icons/layout beyond `renderOption`-style
#' composition, or a non-input target like a `Button()`). See
#' <https://mantine.dev/core/combobox/>.
#'
#' The real Mantine `Combobox` is driven by an imperative `useCombobox()`
#' store (a live JS object with methods); this package creates and owns
#' that store for you internally, so the pieces below stay fully
#' declarative:
#' - `ComboboxTarget()`'s single child (e.g. a [Button()] or [TextInput()])
#'   automatically toggles the dropdown on click — real Mantine requires
#'   wiring this by hand (`onClick={() => combobox.toggleDropdown()}`),
#'   not needed here.
#' - `ComboboxSearch()` is a text field wired to Shiny like any other input
#'   (`input[[inputId]]` on every keystroke) and opens the dropdown on
#'   focus — pair it with [renderMantine()]/[mantineOutput()] to re-render
#'   `ComboboxOptions()` server-side as the user types (server-side
#'   filtering), since an R render function cannot cross the bridge the
#'   way Mantine's own `filter`/`renderOption` props do.
#' - Selecting a `ComboboxOption()` (click or Enter) sends its `value` to
#'   `input[[inputId]]` of the enclosing `Combobox()` (as an event, like
#'   [shiny::actionButton()]) and closes the dropdown. Highlighting the
#'   current selection (`active = TRUE` on the matching `ComboboxOption()`)
#'   is the caller's responsibility, same as Mantine's own controlled
#'   examples.
#'
#' @rdname Combobox
#' @param inputId Id of the Shiny input that receives the submitted
#'   option's value.
#' @param opened Whether the dropdown is open. Toggle from the server with
#'   [updateMantineProps()] (needs a `mantineId`).
#' @param ... Other props and children — typically a [ComboboxTarget()]
#'   and a [ComboboxDropdown()] (`width`, `position`, `shadow`, `withArrow`,
#'   ...).
#' @export
Combobox <- function(..., inputId = NULL, opened = FALSE) {
  mantineElement("Combobox", inputId = inputId, opened = opened, ...)
}

#' @rdname Combobox
#' @export
ComboboxTarget <- displayComponent("Combobox.Target")

#' @rdname Combobox
#' @export
ComboboxEventsTarget <- displayComponent("Combobox.EventsTarget")

#' @rdname Combobox
#' @export
ComboboxDropdownTarget <- displayComponent("Combobox.DropdownTarget")

#' @rdname Combobox
#' @export
ComboboxDropdown <- displayComponent("Combobox.Dropdown")

#' @rdname Combobox
#' @export
ComboboxOptions <- displayComponent("Combobox.Options")

#' @rdname Combobox
#' @param value This option's value, sent to `input[[inputId]]` of the
#'   enclosing [Combobox()] when selected.
#' @export
ComboboxOption <- function(value, ...) {
  mantineElement("Combobox.Option", value = value, ...)
}

#' @rdname Combobox
#' @param inputId Id of the Shiny input that receives the search text on
#'   every keystroke (like [TextInput()]).
#' @param value Initial search text.
#' @export
ComboboxSearch <- function(inputId, value = "", ...) {
  mantineElement("Combobox.Search", inputId = inputId, value = value, ...)
}

#' @rdname Combobox
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineComboboxSearch <- function(
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

#' @rdname Combobox
#' @export
ComboboxEmpty <- displayComponent("Combobox.Empty")

#' @rdname Combobox
#' @export
ComboboxFooter <- displayComponent("Combobox.Footer")

#' @rdname Combobox
#' @export
ComboboxHeader <- displayComponent("Combobox.Header")

#' @rdname Combobox
#' @export
ComboboxGroup <- displayComponent("Combobox.Group")

#' @rdname Combobox
#' @export
ComboboxChevron <- displayComponent("Combobox.Chevron")

#' @rdname Combobox
#' @export
ComboboxClearButton <- displayComponent("Combobox.ClearButton")

#' @rdname Combobox
#' @export
ComboboxHiddenInput <- displayComponent("Combobox.HiddenInput")

# ComboboxPopover: unlike raw Combobox, this is fully declarative already
# in real Mantine (controlled `value`/`onChange`, `data` in the same shape
# as Select()) - it just renders no input of its own, delegating the
# clickable target to a ComboboxPopoverTarget() child. Wired exactly like
# Select().

#' Mantine ComboboxPopover (dropdown-select attached to any custom target)
#'
#' Like [Select()], but renders no input of its own — supply the clickable
#' target (e.g. a [Button()]) via `ComboboxPopoverTarget()`.
#' `input[[inputId]]` is synced on every selection, same as `Select()`.
#'
#' @rdname ComboboxPopover
#' @param inputId Id of the Shiny input; `input[[inputId]]` is synced on
#'   every selection.
#' @param data Options: a character vector, or a list of `list(value=,
#'   label=)` (optionally grouped: `list(group=, items=)`). See
#'   <https://mantine.dev/core/combobox-popover/>.
#' @param value Initial value (or `NULL`); a character vector if `multiple
#'   = TRUE`.
#' @param ... Other props (`searchable`, `multiple`, `nothingFoundMessage`,
#'   ...) and a `ComboboxPopoverTarget()` child.
#' @export
ComboboxPopover <- function(inputId, ..., data = NULL, value = NULL) {
  mantineElement("ComboboxPopover", inputId = inputId, data = data, value = value, ...)
}

#' @rdname ComboboxPopover
#' @export
ComboboxPopoverTarget <- displayComponent("ComboboxPopover.Target")

#' @rdname ComboboxPopover
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineComboboxPopover <- function(
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
