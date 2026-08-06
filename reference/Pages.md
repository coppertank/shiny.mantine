# Page navigation inside an AppShell (client-side router)

`Pages()` keeps the "active page" state entirely on the client: every
[`navLinkItem()`](https://coppertank.github.io/shiny.mantine/reference/navLinkItem.md)
nested in the same hierarchy, when clicked, instantly switches which
`Page()` child is visible — without rebuilding the whole React tree and
without needing a round-trip to the server (unlike a reactive
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html)). The click
is still sent to Shiny via the link's `inputId`, so you can also react
server-side if needed (analytics, side effects, ...).

## Usage

``` r
Pages(active = NULL, ...)

Page(value, ...)
```

## Arguments

- active:

  Initial value of the active page (must match the `value` — or
  `pageValue` — of one of the
  [`navLinkItem()`](https://coppertank.github.io/shiny.mantine/reference/navLinkItem.md)s,
  and the `value` of one of the child `Page()`s).

- ...:

  Content, typically a whole
  [`AppShell()`](https://coppertank.github.io/shiny.mantine/reference/AppShell.md).

- value:

  Page identifier; must match the `value` (or `pageValue`) sent by a
  [`navLinkItem()`](https://coppertank.github.io/shiny.mantine/reference/navLinkItem.md)
  to be selected.

## Details

The whole
[`AppShell()`](https://coppertank.github.io/shiny.mantine/reference/AppShell.md)
is typically nested inside `Pages()`, so both the Navbar (with the
[`navLinkItem()`](https://coppertank.github.io/shiny.mantine/reference/navLinkItem.md)s)
and the Main (with the `Page()`s) share the same navigation state.

## Examples

``` r
if (FALSE) { # \dontrun{
Pages(
  active = "home",
  AppShell(
    AppShellNavbar(
      navLinkItem("navId", "home", "Home"),
      navLinkItem("navId", "settings", "Settings")
    ),
    AppShellMain(
      Page(value = "home", Text("Welcome")),
      Page(value = "settings", Text("Settings"))
    )
  )
)
} # }
```
