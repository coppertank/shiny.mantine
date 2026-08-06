# Mantine Menu submenu (`Menu.Sub`)

Nests a submenu inside a
[`MenuDropdown()`](https://coppertank.github.io/shiny.mantine/reference/Menu.md)
item. `MenuSubItem()` behaves like
[`menuItem()`](https://coppertank.github.io/shiny.mantine/reference/menuItem.md)
(reports `value` to `input[[inputId]]` on click).

## Usage

``` r
MenuSub(...)

MenuSubTarget(...)

MenuSubDropdown(...)

menuSubItem(inputId, value, label, ...)
```

## Arguments

- ...:

  Props and children. See <https://mantine.dev/core/menu/#nested-menus>.

- inputId:

  Id of the Shiny input that receives the selected value.

- value:

  Value sent to Shiny when the item is clicked.

- label:

  Item text.
