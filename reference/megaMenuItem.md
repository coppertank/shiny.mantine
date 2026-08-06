# A mega menu item (icon + title + description)

Composition helper (not a standalone Mantine component) to quickly build
the rows of a mega menu inside
[`HoverCardDropdown()`](https://coppertank.github.io/shiny.mantine/reference/HoverCard.md)
— usually arranged in a
[`SimpleGrid()`](https://coppertank.github.io/shiny.mantine/reference/SimpleGrid.md).
It is plain R code: copy and adapt it freely if you need a different
layout.

## Usage

``` r
megaMenuItem(icon, title, description, ...)
```

## Arguments

- icon:

  An icon element, e.g. `IconCode(size = 22)`.

- title:

  Item title.

- description:

  Short description under the title.

- ...:

  Other props forwarded to `UnstyledButton` (e.g. `onClick` if built
  like
  [`navLinkItem()`](https://coppertank.github.io/shiny.mantine/reference/navLinkItem.md),
  `href`, ...).
