# Mantine OverflowList (collapses overflowing items into a "+N" badge)

Hides items that don't fit in the container and displays them as a
single collapsed indicator. Real Mantine configures this via
`renderItem`/`renderOverflow` (JS render functions, which cannot cross
the R/JSON bridge) — here, pass fully pre-built elements directly as
`...` (one per item, built however you like:
[`Badge()`](https://coppertank.github.io/shiny.mantine/reference/Badge.md)s,
[`Pill()`](https://coppertank.github.io/shiny.mantine/reference/Pill.md)s,
[`Avatar()`](https://coppertank.github.io/shiny.mantine/reference/Avatar.md)s,
...); the ones that don't fit are collapsed into a single
[`Badge()`](https://coppertank.github.io/shiny.mantine/reference/Badge.md)
using `overflowLabel` as a template (`"{n}"` is replaced with the hidden
count).

## Usage

``` r
OverflowList(
  ...,
  overflowLabel = "+{n}",
  gap = NULL,
  maxRows = NULL,
  maxVisibleItems = NULL,
  collapseFrom = NULL
)
```

## Arguments

- ...:

  Pre-built child elements, one per item (e.g. `Badge("Apple")`,
  `Badge("Banana")`, ...).

- overflowLabel:

  Template for the collapsed indicator; `"{n}"` is replaced with the
  number of hidden items.

- gap:

  Key of `theme.spacing` or any valid CSS value for the gap between
  items.

- maxRows:

  Number of rows to display.

- maxVisibleItems:

  Maximum number of visible items.

- collapseFrom:

  `"end"` (default, collapses last items) or `"start"` (collapses first
  items — useful for breadcrumb-like patterns).

## Value

A `mantine_element` to nest inside
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md).
See <https://mantine.dev/core/overflow-list/>.

## Examples

``` r
if (FALSE) { # \dontrun{
OverflowList(
  Badge("Apple"), Badge("Banana"), Badge("Cherry"), Badge("Date"),
  overflowLabel = "+{n} more"
)
} # }
```
