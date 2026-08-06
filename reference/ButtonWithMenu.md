# Button with menu

A button that opens a dropdown menu on click. Items should be passed as
[`menuItem()`](https://coppertank.github.io/shiny.mantine/reference/menuItem.md)
(or
[`MenuLabel()`](https://coppertank.github.io/shiny.mantine/reference/Menu.md)/[`MenuDivider()`](https://coppertank.github.io/shiny.mantine/reference/Menu.md))
among the `...`.

## Usage

``` r
ButtonWithMenu(label, ..., color = "blue")
```

## Arguments

- label:

  Button label.

- ...:

  Menu items (typically
  [`menuItem()`](https://coppertank.github.io/shiny.mantine/reference/menuItem.md))
  and other props forwarded to the `Button` (`variant`, `size`, ...).

- color:

  Button color.

## Examples

``` r
if (FALSE) { # \dontrun{
ButtonWithMenu(
  "Create new",
  menuItem("action", "project", "Project"),
  menuItem("action", "folder", "Folder")
)
} # }
```
