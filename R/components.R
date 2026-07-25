#' @include mantine-element.R
NULL

# Display-only components (no Shiny wiring) ---------

#' Mantine Card
#' @param ... Props and children forwarded to Mantine's `Card` component
#'   (`shadow`, `padding`, `radius`, `withBorder`, ...). See
#'   <https://mantine.dev/core/card/>.
#' @export
Card <- displayComponent("Card")

#' Mantine Text
#' @param ... Props and children forwarded to Mantine's `Text` component
#'   (`size`, `fw`, `c`, `ta`, ...). See <https://mantine.dev/core/text/>.
#' @export
Text <- displayComponent("Text")

#' Mantine Group (horizontal flex layout)
#' @param ... Props and children. See <https://mantine.dev/core/group/>.
#' @export
Group <- displayComponent("Group")

#' Mantine Stack (vertical flex layout)
#' @param ... Props and children. See <https://mantine.dev/core/stack/>.
#' @export
Stack <- displayComponent("Stack")

#' Mantine ScrollArea
#' @param ... Props and children. See <https://mantine.dev/core/scroll-area/>.
#' @export
ScrollArea <- displayComponent("ScrollArea")

# AppShell family ----------------------------------------------------------
# AppShell is Mantine's layout component for handling Header / Navbar /
# Main / Aside responsively. See: https://mantine.dev/core/app-shell/

#' Mantine AppShell family
#'
#' Responsive layout with header/navbar/main/aside/footer. `AppShellHeader()`,
#' `AppShellNavbar()`, `AppShellMain()`, `AppShellAside()`,
#' `AppShellFooter()`, and `AppShellSection()` must be nested inside
#' `AppShell()`. Each of the four slots (`navbar`, `header`, `aside`,
#' `footer`) must first be configured with the matching prop on
#' `AppShell()` itself (`navbar = list(width = ..., breakpoint = ...,
#' collapsed = ...)`, `header = list(height = ...)`, `aside = list(width =
#' ..., breakpoint = ..., collapsed = ...)`, `footer = list(height =
#' ...)`) — otherwise the corresponding slot does not reserve space in the
#' layout. See <https://mantine.dev/core/app-shell/>.
#'
#' @rdname AppShell
#' @param ... Props and children. See <https://mantine.dev/core/app-shell/>.
#' @export
AppShell <- displayComponent("AppShell")

#' @rdname AppShell
#' @export
AppShellHeader <- displayComponent("AppShell.Header")

#' @rdname AppShell
#' @export
AppShellNavbar <- displayComponent("AppShell.Navbar")

#' @rdname AppShell
#' @export
AppShellMain <- displayComponent("AppShell.Main")

#' @rdname AppShell
#' @export
AppShellAside <- displayComponent("AppShell.Aside")

#' @rdname AppShell
#' @export
AppShellFooter <- displayComponent("AppShell.Footer")

#' @rdname AppShell
#' @export
AppShellSection <- displayComponent("AppShell.Section")

# "Click with value" components ----------------------------------------------

#' Mantine NavLink
#' @param ... Props and children forwarded to Mantine's `NavLink`
#'   component. For an item wired to Shiny use [navLinkItem()].
#' @export
NavLink <- function(...) mantineElement("NavLink", ...)

#' Mantine Burger (hamburger icon for a responsive navbar)
#' @param ... Props and children. To wire it to Shiny use [navbarBurger()].
#' @export
Burger <- function(...) mantineElement("Burger", ...)

#' A NavLink item wired to Shiny
#'
#' Every click sends `value` to `input[[inputId]]`. If nested inside
#' [Pages()], the same click also instantly changes, client-side (no
#' server round-trip), which [Page()] is visible — see `?Pages` for page
#' navigation inside an `AppShell`. The item is also automatically
#' highlighted (`active`) when its page is the current one.
#'
#' @param inputId Id of the Shiny input that receives the selected value.
#' @param value Value sent to Shiny when the item is clicked.
#' @param label Menu item text.
#' @param ... Other props forwarded to `NavLink` (`leftSection`,
#'   `description`, ...).
#' @param pageValue Value of the [Page()] to activate on click, if
#'   different from `value` (default: uses `value`).
#' @export
navLinkItem <- function(inputId, value, label, ..., pageValue = NULL) {
  NavLink(label = label, inputId = inputId, value = value, pageValue = pageValue, ...)
}

#' Burger wired to a boolean toggle Shiny input
#'
#' Useful to open/close a responsive navbar on mobile.
#'
#' @param inputId Id of the boolean toggle Shiny input.
#' @param opened Current state (for the icon's animation); the value sent
#'   on click is `!opened`.
#' @param ... Other props forwarded to `Burger` (`size`, `color`, ...).
#' @export
navbarBurger <- function(inputId, opened = FALSE, ...) {
  Burger(inputId = inputId, value = !opened, opened = opened, ...)
}

# Select (Shiny stateful input) ----------------------------------------------

#' Mantine Select (Shiny stateful input)
#'
#' @param inputId Id of the Shiny input; `input[[inputId]]` is synced on
#'   every selection.
#' @param label Field label.
#' @param value Initial value (or `NULL`).
#' @param ... Other props (`data`, `placeholder`, `searchable`, ...). See
#'   <https://mantine.dev/core/select/>.
#' @export
Select <- function(inputId, label = NULL, value = NULL, ...) {
  mantineElement("Select", inputId = inputId, label = label, value = value, ...)
}

#' @rdname Select
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineSelect <- function(session = shiny::getDefaultReactiveDomain(), inputId, value = NULL, ...) {
  session$sendCustomMessage("shinyMantineUpdateInput", list(
    inputId = session$ns(inputId),
    value = value
  ))
}

# Additional layout and decorative components ----------------------------------

#' Mantine Title (h1-h6 headings)
#' @param ... Props and children (`order` = 1..6, `size`, ...). See
#'   <https://mantine.dev/core/title/>.
#' @export
Title <- displayComponent("Title")

#' Mantine Paper (surface with background/shadow/border, without Card's defaults)
#' @param ... Props and children (`shadow`, `radius`, `withBorder`, `p`,
#'   ...). See <https://mantine.dev/core/paper/>.
#' @export
Paper <- displayComponent("Paper")

#' Mantine SimpleGrid (responsive grid with uniform columns)
#' @param ... Props and children (`cols`, `spacing`, ...). See
#'   <https://mantine.dev/core/simple-grid/>.
#' @export
SimpleGrid <- displayComponent("SimpleGrid")

#' Mantine Badge (pill-shaped label)
#' @param ... Props and children (`color`, `variant`, `size`, ...). See
#'   <https://mantine.dev/core/badge/>.
#' @export
Badge <- displayComponent("Badge")

#' Mantine Divider (separator line)
#' @param ... Props (`label`, `my`, ...). See <https://mantine.dev/core/divider/>.
#' @export
Divider <- displayComponent("Divider")

#' Mantine Avatar
#' @param ... Props and children (`src`, `radius`, `color`, `size`, ...).
#'   See <https://mantine.dev/core/avatar/>.
#' @export
Avatar <- displayComponent("Avatar")

#' Mantine ThemeIcon (colored container for icons)
#' @param ... Props and children (`color`, `variant`, `size`, `radius`,
#'   ...). See <https://mantine.dev/core/theme-icon/>.
#' @export
ThemeIcon <- displayComponent("ThemeIcon")

#' Mantine Container
#' @param ... Props and children (`size`, `fluid`, ...). See
#'   <https://mantine.dev/core/container/>.
#' @export
Container <- displayComponent("Container")

#' Mantine Box (generic styleable container)
#' @param ... Props and children. See <https://mantine.dev/core/box/>.
#' @export
Box <- displayComponent("Box")

#' Mantine Grid family (12-column grid)
#'
#' `GridCol()` must be nested inside `Grid()`.
#'
#' @rdname Grid
#' @param ... Props and children (`gutter`, ...) for `Grid()`; (`span`,
#'   `offset`, ...) for `GridCol()`. See <https://mantine.dev/core/grid/>.
#' @export
Grid <- displayComponent("Grid")

#' @rdname Grid
#' @export
GridCol <- displayComponent("Grid.Col")

# HoverCard and menu/dropdown primitives -------------------------------------
# Mantine does not ship a "mega menu" or "header search" component: they
# are recipes built by composing these primitives (see also
# megaMenuItem() and the demo in inst/examples/appshell-app.R).

#' Mantine HoverCard family (dropdown on hover)
#'
#' Base for building a "mega menu" header: `HoverCardTarget()` wraps the
#' element that opens the dropdown on hover (must have exactly one child),
#' `HoverCardDropdown()` contains the panel that appears (typically a
#' `SimpleGrid()` of [megaMenuItem()]s).
#'
#' @rdname HoverCard
#' @param ... Props and children (`width`, `position`, `shadow`, `radius`,
#'   `withinPortal`, ...) for `HoverCard()`. See
#'   <https://mantine.dev/core/hover-card/>.
#' @export
HoverCard <- displayComponent("HoverCard")

#' @rdname HoverCard
#' @export
HoverCardTarget <- displayComponent("HoverCard.Target")

#' @rdname HoverCard
#' @export
HoverCardDropdown <- displayComponent("HoverCard.Dropdown")

#' @rdname HoverCard
#' @export
HoverCardGroup <- displayComponent("HoverCard.Group")

#' Mantine UnstyledButton (button with no default styling, for building custom elements)
#' @param ... Props and children. See <https://mantine.dev/core/unstyled-button/>.
#' @export
UnstyledButton <- displayComponent("UnstyledButton")

#' Mantine Center (centers content horizontally and vertically)
#' @param ... Props and children. See <https://mantine.dev/core/center/>.
#' @export
Center <- displayComponent("Center")

#' Mantine Anchor (styled link)
#' @param ... Props and children (`href`, `underline`, `c`, ...). See
#'   <https://mantine.dev/core/anchor/>.
#' @export
Anchor <- displayComponent("Anchor")

#' Mantine Tabs family
#'
#' `Tabs()` (the container) is "aware" of the [Pages()] router: if nested
#' inside it, selecting a tab changes which [Page()] is visible — exactly
#' like [navLinkItem()] — useful to offer the same navigation both in the
#' Navbar (with `NavLink`) and in a header (with `Tabs`), staying in sync.
#' Each `TabsTab()`'s `value` must match the `value` of a `Page()`. When
#' used outside `Pages()`, it behaves like a normal controlled `Tabs`
#' (local state).
#'
#' @rdname Tabs
#' @param ... Props and children for `Tabs()` (typically a [TabsList()]
#'   containing `TabsTab()`s); for `TabsTab()`/`TabsPanel()`, other props
#'   (`leftSection`, ...) and the content (label or panel) as an unnamed
#'   child. See <https://mantine.dev/core/tabs/>.
#' @param inputId If provided, every tab change also sends
#'   `input[[inputId]]` (the selected tab's `value`) — you can reuse the
#'   same `inputId` as [navLinkItem()] to have them feed into the same
#'   Shiny input.
#' @export
Tabs <- function(..., inputId = NULL) {
  mantineElement("Tabs", inputId = inputId, ...)
}

#' @rdname Tabs
#' @export
TabsList <- displayComponent("Tabs.List")

#' @rdname Tabs
#' @param value Tab identifier (must match the `value` of a [Page()] to
#'   participate in page navigation).
#' @export
TabsTab <- function(value, ...) {
  mantineElement("Tabs.Tab", value = value, ...)
}

#' @rdname Tabs
#' @export
TabsPanel <- function(value, ...) {
  mantineElement("Tabs.Panel", value = value, ...)
}

#' A mega menu item (icon + title + description)
#'
#' Composition helper (not a standalone Mantine component) to quickly
#' build the rows of a mega menu inside [HoverCardDropdown()] — usually
#' arranged in a [SimpleGrid()]. It is plain R code: copy and adapt it
#' freely if you need a different layout.
#'
#' @param icon An icon element, e.g. `IconCode(size = 22)`.
#' @param title Item title.
#' @param description Short description under the title.
#' @param ... Other props forwarded to `UnstyledButton` (e.g. `onClick` if
#'   built like [navLinkItem()], `href`, ...).
#' @export
megaMenuItem <- function(icon, title, description, ...) {
  UnstyledButton(
    p = "sm",
    style = list(borderRadius = 8, display = "block", width = "100%"),
    ...,
    Group(
      wrap = "nowrap",
      align = "flex-start",
      ThemeIcon(icon, size = 34, variant = "light", radius = "md"),
      Stack(
        gap = 2,
        Text(title, size = "sm", fw = 500),
        Text(description, size = "xs", c = "dimmed")
      )
    )
  )
}

# Icons (tabler-icons, a small curated subset) -----------------------
# More icons can be added the same way: import them in js/src/index.js
# from '@tabler/icons-react' and register them in the `components` object.

#' Tabler icons
#'
#' A small subset of <https://tabler.io/icons> already registered in the
#' JS bundle. Common props: `size`, `color`, `stroke`.
#'
#' @rdname icons
#' @param ... Props (`size`, `color`, `stroke`, ...).
#' @export
IconHome2 <- displayComponent("IconHome2")

#' @rdname icons
#' @export
IconLayoutDashboard <- displayComponent("IconLayoutDashboard")

#' @rdname icons
#' @export
IconSettings <- displayComponent("IconSettings")

#' @rdname icons
#' @export
IconUsers <- displayComponent("IconUsers")

#' @rdname icons
#' @export
IconPlus <- displayComponent("IconPlus")

#' @rdname icons
#' @export
IconBrandTwitter <- displayComponent("IconBrandTwitter")

#' @rdname icons
#' @export
IconBrandInstagram <- displayComponent("IconBrandInstagram")

#' @rdname icons
#' @export
IconBrandYoutube <- displayComponent("IconBrandYoutube")

#' @rdname icons
#' @export
IconBrandLinkedin <- displayComponent("IconBrandLinkedin")

#' @rdname icons
#' @export
IconArrowUpRight <- displayComponent("IconArrowUpRight")

#' @rdname icons
#' @export
IconArrowDownRight <- displayComponent("IconArrowDownRight")

#' @rdname icons
#' @export
IconTrendingUp <- displayComponent("IconTrendingUp")

#' @rdname icons
#' @export
IconTrendingDown <- displayComponent("IconTrendingDown")

#' @rdname icons
#' @export
IconPhone <- displayComponent("IconPhone")

#' @rdname icons
#' @export
IconMail <- displayComponent("IconMail")

#' @rdname icons
#' @export
IconGripVertical <- displayComponent("IconGripVertical")

#' @rdname icons
#' @export
IconUpload <- displayComponent("IconUpload")

#' @rdname icons
#' @export
IconX <- displayComponent("IconX")

#' @rdname icons
#' @export
IconMapPin <- displayComponent("IconMapPin")

#' @rdname icons
#' @export
IconHeart <- displayComponent("IconHeart")

#' @rdname icons
#' @export
IconStar <- displayComponent("IconStar")

#' @rdname icons
#' @export
IconDots <- displayComponent("IconDots")

#' @rdname icons
#' @export
IconEdit <- displayComponent("IconEdit")

#' @rdname icons
#' @export
IconTrash <- displayComponent("IconTrash")

#' @rdname icons
#' @export
IconLogout <- displayComponent("IconLogout")

#' @rdname icons
#' @export
IconChevronRight <- displayComponent("IconChevronRight")

#' @rdname icons
#' @export
IconSearch <- displayComponent("IconSearch")

#' @rdname icons
#' @export
IconChevronDown <- displayComponent("IconChevronDown")

#' @rdname icons
#' @export
IconCode <- displayComponent("IconCode")

#' @rdname icons
#' @export
IconBook <- displayComponent("IconBook")

#' @rdname icons
#' @export
IconChartBar <- displayComponent("IconChartBar")

#' @rdname icons
#' @export
IconFingerprint <- displayComponent("IconFingerprint")

#' @rdname icons
#' @export
IconChartLine <- displayComponent("IconChartLine")

#' @rdname icons
#' @export
IconChartPie <- displayComponent("IconChartPie")

#' @rdname icons
#' @export
IconFileText <- displayComponent("IconFileText")

#' @rdname icons
#' @export
IconBell <- displayComponent("IconBell")

#' @rdname icons
#' @export
IconExternalLink <- displayComponent("IconExternalLink")

#' @rdname icons
#' @export
IconDownload <- displayComponent("IconDownload")

#' @rdname icons
#' @export
IconCurrencyDollar <- displayComponent("IconCurrencyDollar")

#' @rdname icons
#' @export
IconPercentage <- displayComponent("IconPercentage")

#' @rdname icons
#' @export
IconCategory <- displayComponent("IconCategory")
