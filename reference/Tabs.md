# Mantine Tabs family

`Tabs()` (the container) is "aware" of the
[`Pages()`](https://coppertank.github.io/shiny.mantine/reference/Pages.md)
router: if nested inside it, selecting a tab changes which
[`Page()`](https://coppertank.github.io/shiny.mantine/reference/Pages.md)
is visible — exactly like
[`navLinkItem()`](https://coppertank.github.io/shiny.mantine/reference/navLinkItem.md)
— useful to offer the same navigation both in the Navbar (with
`NavLink`) and in a header (with `Tabs`), staying in sync. Each
`TabsTab()`'s `value` must match the `value` of a
[`Page()`](https://coppertank.github.io/shiny.mantine/reference/Pages.md).
When used outside
[`Pages()`](https://coppertank.github.io/shiny.mantine/reference/Pages.md),
it behaves like a normal controlled `Tabs` (local state).

## Usage

``` r
Tabs(..., inputId = NULL)

TabsList(...)

TabsTab(value, ...)

TabsPanel(value, ...)
```

## Arguments

- ...:

  Props and children for `Tabs()` (typically a `TabsList()` containing
  `TabsTab()`s); for `TabsTab()`/`TabsPanel()`, other props
  (`leftSection`, ...) and the content (label or panel) as an unnamed
  child. See <https://mantine.dev/core/tabs/>.

- inputId:

  If provided, every tab change also sends `input[[inputId]]` (the
  selected tab's `value`) — you can reuse the same `inputId` as
  [`navLinkItem()`](https://coppertank.github.io/shiny.mantine/reference/navLinkItem.md)
  to have them feed into the same Shiny input.

- value:

  Tab identifier (must match the `value` of a
  [`Page()`](https://coppertank.github.io/shiny.mantine/reference/Pages.md)
  to participate in page navigation).
