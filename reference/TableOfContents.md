# Mantine TableOfContents (tracks scroll position over page headings)

Renders a list of the page's headings and highlights whichever is
currently visible in the viewport as the user scrolls; clicking an entry
scrolls it into view. This mirrors Mantine's own documented recipe
(`getControlProps` calling `data.getNode().scrollIntoView()`, the
heading text as label) — the only supported behavior, since
`getControlProps`/`scrollSpyOptions`'s `getDepth`/`getValue` are JS
callbacks and cannot cross the R/JSON bridge.

## Usage

``` r
TableOfContents(scrollSpySelector = "h1, h2, h3, h4, h5, h6", ...)
```

## Arguments

- scrollSpySelector:

  CSS selector for the headings to track (passed as
  `scrollSpyOptions$selector`), e.g. `"#content :is(h1, h2, h3)"`.
  Defaults to every `h1`-`h6` on the page.

- ...:

  Other props (`size`, `color`, `radius`, `variant`, `autoContrast`,
  `minDepthToOffset`, `depthOffset`, `initialData`, ...). See
  <https://mantine.dev/core/table-of-contents/>.

## Value

A `mantine_element` to nest inside
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md).

## Examples

``` r
if (FALSE) { # \dontrun{
TableOfContents(scrollSpySelector = "#content h1, #content h2, #content h3")
} # }
```
