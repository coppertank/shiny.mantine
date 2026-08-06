# Mantine HoverCard family (dropdown on hover)

Base for building a "mega menu" header: `HoverCardTarget()` wraps the
element that opens the dropdown on hover (must have exactly one child),
`HoverCardDropdown()` contains the panel that appears (typically a
[`SimpleGrid()`](https://coppertank.github.io/shiny.mantine/reference/SimpleGrid.md)
of
[`megaMenuItem()`](https://coppertank.github.io/shiny.mantine/reference/megaMenuItem.md)s).

## Usage

``` r
HoverCard(...)

HoverCardTarget(...)

HoverCardDropdown(...)

HoverCardGroup(...)
```

## Arguments

- ...:

  Props and children (`width`, `position`, `shadow`, `radius`,
  `withinPortal`, ...) for `HoverCard()`. See
  <https://mantine.dev/core/hover-card/>.
