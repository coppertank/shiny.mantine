# A Menu item wired to Shiny

Every click sends `value` to `input[[inputId]]` (same pattern as
[`navLinkItem()`](https://coppertank.github.io/shiny.mantine/reference/navLinkItem.md)).
Nest it inside
[`MenuDropdown()`](https://coppertank.github.io/shiny.mantine/reference/Menu.md)
— or directly among the `...` of
[`ButtonWithMenu()`](https://coppertank.github.io/shiny.mantine/reference/ButtonWithMenu.md)/[`SplitButton()`](https://coppertank.github.io/shiny.mantine/reference/SplitButton.md).

## Usage

``` r
menuItem(inputId, value, label, ...)
```

## Arguments

- inputId:

  Id of the Shiny input that receives the selected value.

- value:

  Value sent to Shiny when the item is clicked.

- label:

  Item text.

- ...:

  Other props forwarded to `Menu.Item` (`leftSection`, `color`, ...).
