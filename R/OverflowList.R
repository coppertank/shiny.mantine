#' @include mantine-element.R
NULL

#' Mantine OverflowList (collapses overflowing items into a "+N" badge)
#'
#' Hides items that don't fit in the container and displays them as a
#' single collapsed indicator. Real Mantine configures this via
#' `renderItem`/`renderOverflow` (JS render functions, which cannot cross
#' the R/JSON bridge) — here, pass fully pre-built elements directly as
#' `...` (one per item, built however you like: [Badge()]s, [Pill()]s,
#' [Avatar()]s, ...); the ones that don't fit are collapsed into a single
#' [Badge()] using `overflowLabel` as a template (`"{n}"` is replaced with
#' the hidden count).
#'
#' @param ... Pre-built child elements, one per item (e.g. `Badge("Apple")`,
#'   `Badge("Banana")`, ...).
#' @param overflowLabel Template for the collapsed indicator; `"{n}"` is
#'   replaced with the number of hidden items.
#' @param gap Key of `theme.spacing` or any valid CSS value for the gap
#'   between items.
#' @param maxRows Number of rows to display.
#' @param maxVisibleItems Maximum number of visible items.
#' @param collapseFrom `"end"` (default, collapses last items) or
#'   `"start"` (collapses first items — useful for breadcrumb-like
#'   patterns).
#' @return A `mantine_element` to nest inside [MantineProvider()]. See
#'   <https://mantine.dev/core/overflow-list/>.
#' @export
#' @examples
#' \dontrun{
#' OverflowList(
#'   Badge("Apple"), Badge("Banana"), Badge("Cherry"), Badge("Date"),
#'   overflowLabel = "+{n} more"
#' )
#' }
OverflowList <- function(
  ...,
  overflowLabel = "+{n}",
  gap = NULL,
  maxRows = NULL,
  maxVisibleItems = NULL,
  collapseFrom = NULL
) {
  mantineElement(
    "OverflowList",
    overflowLabel = overflowLabel,
    gap = gap,
    maxRows = maxRows,
    maxVisibleItems = maxVisibleItems,
    collapseFrom = collapseFrom,
    ...
  )
}
