#' Update arbitrary props of a mounted component (generic channel)
#'
#' Unlike `updateMantineTextInput()` and friends (which only update an
#' input's `value`), this function updates *any* simple prop (strings,
#' numbers, booleans, lists — not nested component trees) of *any*
#' component that has a matching `mantineId` prop. This is the mechanism
#' that makes it possible, for example, to open and close
#' `Modal()`/`Drawer()`/`Dialog()` from R (the `opened` prop), or to
#' dynamically change a component's `disabled`/`color`/`label` without
#' rebuilding the whole tree.
#'
#' Not every component supports `mantineId`: it is supported by overlays
#' (`Modal`, `Drawer`, `Dialog`, `Popover`, `Affix`, `LoadingOverlay`),
#' feedback elements (`Alert`, `Badge`, `Indicator`) and every stateful
#' input (`TextInput`, `Select`, `Switch`, `Checkbox`, `Autocomplete`,
#' `NumberInput`, `PasswordInput`, `SegmentedControl`, `Slider`,
#' `RangeSlider`) — for the latter this complements (does not replace)
#' `updateMantineTextInput()` and friends, which remain the dedicated way
#' to update `value`.
#'
#' To update *nested content* (e.g. a `Modal`'s children) rather than
#' simple props, use [mantineOutput()]/[renderMantine()], which
#' reactively recompute an entire sub-tree.
#'
#' @param session Session object passed to the Shiny server function.
#' @param mantineId The value passed as `mantineId = "..."` to the
#'   component you want to update.
#' @param ... The props to update (valid names for the target Mantine
#'   component), as named arguments.
#' @return None. Called for its side effect.
#' @export
#' @examples
#' \dontrun{
#' # server:
#' observeEvent(input$open_modal_btn, {
#'   updateMantineProps(session, "my_modal", opened = TRUE)
#' })
#' observeEvent(input$close_modal_btn, {
#'   updateMantineProps(session, "my_modal", opened = FALSE)
#' })
#' }
updateMantineProps <- function(
  session = shiny::getDefaultReactiveDomain(),
  mantineId,
  ...
) {
  session$sendCustomMessage(
    "shinyMantineUpdateProps",
    list(
      id = session$ns(mantineId),
      props = list(...)
    )
  )
}
