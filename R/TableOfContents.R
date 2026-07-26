#' @include mantine-element.R
NULL

#' Mantine TableOfContents (tracks scroll position over page headings)
#'
#' Renders a list of the page's headings and highlights whichever is
#' currently visible in the viewport as the user scrolls; clicking an
#' entry scrolls it into view. This mirrors Mantine's own documented
#' recipe (`getControlProps` calling `data.getNode().scrollIntoView()`, the
#' heading text as label) — the only supported behavior, since
#' `getControlProps`/`scrollSpyOptions`'s `getDepth`/`getValue` are JS
#' callbacks and cannot cross the R/JSON bridge.
#'
#' @param scrollSpySelector CSS selector for the headings to track (passed
#'   as `scrollSpyOptions$selector`), e.g. `"#content :is(h1, h2, h3)"`.
#'   Defaults to every `h1`-`h6` on the page.
#' @param ... Other props (`size`, `color`, `radius`, `variant`,
#'   `autoContrast`, `minDepthToOffset`, `depthOffset`, `initialData`,
#'   ...). See <https://mantine.dev/core/table-of-contents/>.
#' @return A `mantine_element` to nest inside [MantineProvider()].
#' @export
#' @examples
#' \dontrun{
#' TableOfContents(scrollSpySelector = "#content h1, #content h2, #content h3")
#' }
TableOfContents <- function(scrollSpySelector = "h1, h2, h3, h4, h5, h6", ...) {
  mantineElement("TableOfContents", scrollSpySelector = scrollSpySelector, ...)
}
