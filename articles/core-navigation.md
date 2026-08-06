# Core: Navigation

``` r

library(shiny)
library(shiny.mantine)
```

An R rewrite of the [“Navigation”
category](https://mantine.dev/core/anchor/) on mantine.dev/core.
[`Menu()`](https://coppertank.github.io/shiny.mantine/reference/Menu.md)/[`Menubar()`](https://coppertank.github.io/shiny.mantine/reference/Menubar.md)
are covered in
[`vignette("core-overlays")`](https://coppertank.github.io/shiny.mantine/articles/core-overlays.md)
instead, matching mantine.dev’s own categorization of them as overlays,
not navigation.

## Anchor

<https://mantine.dev/core/anchor/> — a styled `<a>` link; also usable
`component = "button"`-style for a link-styled clickable action.

``` r

Anchor(href = "https://mantine.dev", target = "_blank", "Mantine documentation")
```

## Breadcrumbs

<https://mantine.dev/core/breadcrumbs/> — a navigation trail (Home \>
Section \> Page), separating its children with `separator`.

``` r

Breadcrumbs(Anchor(href = "#", "Home"), Anchor(href = "#", "Settings"), Text("Profile"))
```

## Burger

<https://mantine.dev/core/burger/> — the hamburger-menu icon button that
animates between open/closed states, typically toggling a navbar’s
mobile visibility.
[`navbarBurger()`](https://coppertank.github.io/shiny.mantine/reference/navbarBurger.md)
is a small convenience wrapper that also reports each click’s resulting
`opened` value to Shiny (the plain
[`Burger()`](https://coppertank.github.io/shiny.mantine/reference/Burger.md)
alone only reports a click counter, like
[`Button()`](https://coppertank.github.io/shiny.mantine/reference/Button.md)):

``` r

navbarBurger(inputId = "nav_opened", opened = FALSE, hiddenFrom = "sm")

# server:
observeEvent(input$nav_opened, {
  updateMantineProps(session, "app_shell", navbar = list(collapsed = list(mobile = !input$nav_opened)))
})
```

## NavLink

<https://mantine.dev/core/nav-link/> — a clickable navigation row
(label, optional icon/description, active state), the building block of
sidebar navigation.
[`navLinkItem()`](https://coppertank.github.io/shiny.mantine/reference/navLinkItem.md)
wraps it with the click-reporting pattern shared by every menu-like item
in this package:

``` r

Stack(
  navLinkItem("nav_click", "dashboard", "Dashboard", leftSection = IconLayoutDashboard(size = 16)),
  navLinkItem("nav_click", "settings", "Settings", leftSection = IconSettings(size = 16), active = TRUE)
)
```

Nested inside
[`Pages()`](https://coppertank.github.io/shiny.mantine/reference/Pages.md),
[`navLinkItem()`](https://coppertank.github.io/shiny.mantine/reference/navLinkItem.md)’s
`pageValue` also drives which
[`Page()`](https://coppertank.github.io/shiny.mantine/reference/Pages.md)
is shown client-side with no server round-trip — see
[`vignette("getting-started")`](https://coppertank.github.io/shiny.mantine/articles/getting-started.md)’s
AppShell example.

## Pagination

<https://mantine.dev/core/pagination/> — page-number controls, stateful:
`input[[inputId]]` is the current page.

``` r

Pagination(inputId = "page", total = 10, value = 1, siblings = 1, boundaries = 1)
```

For a fully custom arrangement of the prev/next/first/last controls
instead of the default layout, use the compound form —
[`PaginationRoot()`](https://coppertank.github.io/shiny.mantine/reference/PaginationRoot.md) +
[`PaginationFirst()`](https://coppertank.github.io/shiny.mantine/reference/PaginationFirst.md)/[`PaginationPrevious()`](https://coppertank.github.io/shiny.mantine/reference/PaginationPrevious.md)/
[`PaginationItems()`](https://coppertank.github.io/shiny.mantine/reference/PaginationItems.md)/[`PaginationNext()`](https://coppertank.github.io/shiny.mantine/reference/PaginationNext.md)/[`PaginationLast()`](https://coppertank.github.io/shiny.mantine/reference/PaginationLast.md)/
[`PaginationDots()`](https://coppertank.github.io/shiny.mantine/reference/PaginationDots.md)/[`PaginationControl()`](https://coppertank.github.io/shiny.mantine/reference/PaginationControl.md)/[`PaginationLabel()`](https://coppertank.github.io/shiny.mantine/reference/PaginationLabel.md)
— which read the current page from
[`PaginationRoot()`](https://coppertank.github.io/shiny.mantine/reference/PaginationRoot.md)
automatically:

``` r

PaginationRoot(
  inputId = "page2", total = 10,
  Group(PaginationFirst(), PaginationPrevious(), PaginationItems(), PaginationNext(), PaginationLast())
)
```

## Stepper

<https://mantine.dev/core/stepper/> — a multi-step wizard indicator.
Unlike most inputs, the active step is **not** synced automatically on
click —
[`StepperStep()`](https://coppertank.github.io/shiny.mantine/reference/Stepper.md)’s
click is reported as an “event” (like a button), and moving to the next
step is entirely up to your own server-side logic (e.g. after validating
the current step), advanced with
[`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md):

``` r

Stepper(
  mantineId = "wizard", inputId = "wizard_click", active = 0,
  StepperStep(label = "Account", description = "Create your account"),
  StepperStep(label = "Details", description = "Add your details"),
  StepperCompleted(Text("Setup complete!"))
)

# server:
observeEvent(input$wizard_click, {
  updateMantineProps(session, "wizard", active = input$wizard_click + 1)
})
```

## Tabs

<https://mantine.dev/core/tabs/> — tabbed navigation; stateful,
`input[[inputId]]` is the active tab’s `value`. When nested inside
[`Pages()`](https://coppertank.github.io/shiny.mantine/reference/Pages.md),
it also drives which
[`Page()`](https://coppertank.github.io/shiny.mantine/reference/Pages.md)
is visible (see
[`vignette("getting-started")`](https://coppertank.github.io/shiny.mantine/articles/getting-started.md)).

``` r

Tabs(
  inputId = "active_tab", value = "account",
  TabsList(TabsTab("account", "Account"), TabsTab("security", "Security")),
  TabsPanel("account", Text("Account settings")),
  TabsPanel("security", Text("Security settings"))
)
```

## Tree

<https://mantine.dev/core/tree/> — hierarchical, expandable/collapsible
data (e.g. a file explorer). Selecting a node reports its `value` to
Shiny as an event, the same pattern as a menu item click.

``` r

Tree(
  inputId = "tree_click",
  data = list(
    list(value = "src", label = "src", children = list(
      list(value = "src/app.R", label = "app.R"),
      list(value = "src/utils.R", label = "utils.R")
    )),
    list(value = "readme", label = "README.md")
  )
)
```

## TableOfContents (not wrapped)

<https://mantine.dev/core/table-of-contents/> requires scanning real
page DOM headings via `getRootElement`/`getControlProps` callbacks — a
poor fit for a declarative, data-only R wrapper. Not covered.

## Where to go next

- [`vignette("core-overlays")`](https://coppertank.github.io/shiny.mantine/articles/core-overlays.md)
  —
  [`Menu()`](https://coppertank.github.io/shiny.mantine/reference/Menu.md)/[`Menubar()`](https://coppertank.github.io/shiny.mantine/reference/Menubar.md)
  and every overlay component (modals, drawers, popovers, tooltips, …).
- [`vignette("core-buttons")`](https://coppertank.github.io/shiny.mantine/articles/core-buttons.md)
  — plain clickable buttons and icon buttons.
