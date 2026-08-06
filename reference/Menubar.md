# Mantine Menubar

A horizontal bar of menus (File/Edit/View-style), distinct from a single
dropdown
[`Menu()`](https://coppertank.github.io/shiny.mantine/reference/Menu.md).
`MenubarMenu()` groups one menu's target + dropdown; items inside
`MenubarDropdown()` are plain
[`menuItem()`](https://coppertank.github.io/shiny.mantine/reference/menuItem.md)
calls.

## Usage

``` r
Menubar(...)

MenubarMenu(...)

MenubarTarget(...)

MenubarDropdown(...)
```

## Arguments

- ...:

  Props and children. See <https://mantine.dev/core/menubar/>.
