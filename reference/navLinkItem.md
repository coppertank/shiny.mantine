# A NavLink item wired to Shiny

Every click sends `value` to `input[[inputId]]`. If nested inside
[`Pages()`](https://coppertank.github.io/shiny.mantine/reference/Pages.md),
the same click also instantly changes, client-side (no server
round-trip), which
[`Page()`](https://coppertank.github.io/shiny.mantine/reference/Pages.md)
is visible — see
[`?Pages`](https://coppertank.github.io/shiny.mantine/reference/Pages.md)
for page navigation inside an `AppShell`. The item is also automatically
highlighted (`active`) when its page is the current one.

## Usage

``` r
navLinkItem(inputId, value, label, ..., pageValue = NULL)
```

## Arguments

- inputId:

  Id of the Shiny input that receives the selected value.

- value:

  Value sent to Shiny when the item is clicked.

- label:

  Menu item text.

- ...:

  Other props forwarded to `NavLink` (`leftSection`, `description`,
  ...).

- pageValue:

  Value of the
  [`Page()`](https://coppertank.github.io/shiny.mantine/reference/Pages.md)
  to activate on click, if different from `value` (default: uses
  `value`).
