#' @include mantine-element.R
NULL

# "Buttons" components inspired by https://ui.mantine.dev/category/buttons/
#
# That page shows recipes (code to compose), not standalone Mantine
# components — same situation already seen for the mega menu/header. Where
# the recipe requires real state/hooks (color scheme, clipboard, a dropdown
# anchored to a button) it was implemented as a dedicated JS component (see
# js/src/index.js); "Social buttons" instead is pure R composition on top
# of the existing Button(), no extra JS needed.

# Menu primitives (for ButtonWithMenu()/SplitButton(), or general use) --------

#' Mantine Menu family (dropdown on click)
#'
#' Generic base for dropdown menus. For the ready-to-use "Button with menu"
#' and "Split button" patterns see [ButtonWithMenu()] and [SplitButton()];
#' use these primitives only if you need a `Menu` with a target other than
#' a button.
#'
#' @rdname Menu
#' @param ... Props and children. See <https://mantine.dev/core/menu/>.
#' @export
Menu <- displayComponent("Menu")

#' @rdname Menu
#' @export
MenuTarget <- displayComponent("Menu.Target")

#' @rdname Menu
#' @export
MenuDropdown <- displayComponent("Menu.Dropdown")

#' @rdname Menu
#' @export
MenuLabel <- displayComponent("Menu.Label")

#' @rdname Menu
#' @export
MenuDivider <- displayComponent("Menu.Divider")

#' A Menu item wired to Shiny
#'
#' Every click sends `value` to `input[[inputId]]` (same pattern as
#' [navLinkItem()]). Nest it inside [MenuDropdown()] — or directly among
#' the `...` of [ButtonWithMenu()]/[SplitButton()].
#'
#' @param inputId Id of the Shiny input that receives the selected value.
#' @param value Value sent to Shiny when the item is clicked.
#' @param label Item text.
#' @param ... Other props forwarded to `Menu.Item` (`leftSection`, `color`,
#'   ...).
#' @export
menuItem <- function(inputId, value, label, ...) {
  mantineElement("Menu.Item", label, inputId = inputId, value = value, ...)
}

# Other primitives used by the components below -----------------------------

#' Mantine ActionIcon (icon-only button)
#' @param ... Props and children (usually a single icon). See
#'   <https://mantine.dev/core/action-icon/>.
#' @export
ActionIcon <- displayComponent("ActionIcon")

#' Mantine Progress (progress bar)
#' @param ... Props (`value`, `color`, `size`, ...). See
#'   <https://mantine.dev/core/progress/>.
#' @export
Progress <- displayComponent("Progress")

#' Mantine Button.Group (visually groups several Button together)
#' @param ... Props and children. See <https://mantine.dev/core/button/#buttongroup>.
#' @export
ButtonGroup <- displayComponent("Button.Group")

# The 6 components from https://ui.mantine.dev/category/buttons/ ----------------

#' Color scheme toggle
#'
#' Icon button (sun/moon) that toggles the whole [MantineProvider()]'s
#' light/dark theme — uses Mantine's `useMantineColorScheme()` hook.
#'
#' @param inputId If provided, every toggle sends the new theme
#'   (`"light"`/`"dark"`) to `input[[inputId]]`.
#' @param ... Other props forwarded to `ActionIcon` (`size`, `variant`, ...).
#' @export
ColorSchemeToggle <- function(inputId = NULL, ...) {
  mantineElement("ColorSchemeToggle", inputId = inputId, ...)
}

#' Copy to clipboard button
#'
#' Copies `value` to the clipboard and shows "Copied" for a few moments
#' (uses Mantine's real `CopyButton` internally).
#'
#' @param value Text to copy.
#' @param label Label before copying.
#' @param copiedLabel Label shown right after copying.
#' @param inputId If provided, every copy sends `value` to
#'   `input[[inputId]]` (useful to know server-side what was copied).
#' @param ... Other props forwarded to the underlying `Button` (`variant`,
#'   `size`, ...).
#' @export
CopyButton <- function(
  value,
  label = "Copy",
  copiedLabel = "Copied",
  inputId = NULL,
  ...
) {
  mantineElement(
    "CopyButton",
    value = value,
    label = label,
    copiedLabel = copiedLabel,
    inputId = inputId,
    ...
  )
}

#' Button with menu
#'
#' A button that opens a dropdown menu on click. Items should be passed as
#' [menuItem()] (or [MenuLabel()]/[MenuDivider()]) among the `...`.
#'
#' @param label Button label.
#' @param ... Menu items (typically [menuItem()]) and other props
#'   forwarded to the `Button` (`variant`, `size`, ...).
#' @param color Button color.
#' @export
#' @examples
#' \dontrun{
#' ButtonWithMenu(
#'   "Create new",
#'   menuItem("action", "project", "Project"),
#'   menuItem("action", "folder", "Folder")
#' )
#' }
ButtonWithMenu <- function(label, ..., color = "blue") {
  mantineElement("ButtonWithMenu", label = label, color = color, ...)
}

#' Split button
#'
#' A primary action (button, clicks increment `input[[inputId]]` like
#' [Button()]) paired with a small arrow that opens a menu of alternative
#' actions — items should be passed as [menuItem()] among the `...`.
#'
#' @param label Label of the primary action.
#' @param inputId Id of the Shiny input incremented by clicking the
#'   primary action.
#' @param ... Items of the alternative menu (typically [menuItem()]) and
#'   other props forwarded to the primary `Button`.
#' @param color Color shared by the button and the arrow.
#' @export
#' @examples
#' \dontrun{
#' SplitButton(
#'   "Send",
#'   inputId = "send_btn",
#'   menuItem("send_action", "now", "Send now"),
#'   menuItem("send_action", "schedule", "Schedule send")
#' )
#' }
SplitButton <- function(label, inputId = NULL, ..., color = "blue") {
  mantineElement(
    "SplitButton",
    label = label,
    inputId = inputId,
    color = color,
    ...
  )
}

#' Button with loading progress
#'
#' On click, shows a simulated progress bar over the button (disabled
#' during loading). When the bar reaches 100%, `input[[inputId]]` receives
#' `TRUE`.
#'
#' @param label Normal button label.
#' @param inputId If provided, receives `TRUE` on completion.
#' @param loadingLabel Label shown while loading.
#' @param ... Other props forwarded to the underlying `Button`.
#' @export
LoadingProgressButton <- function(
  label,
  inputId = NULL,
  loadingLabel = "Loading...",
  ...
) {
  mantineElement(
    "LoadingProgressButton",
    label = label,
    inputId = inputId,
    loadingLabel = loadingLabel,
    ...
  )
}

#' Social buttons
#'
#' A preconfigured (icon + color) button for a common provider. Pure R
#' code on top of [Button()] — copy and adapt it if you need a provider
#' other than the ones included.
#'
#' @param provider One of `"google"`, `"twitter"`, `"facebook"`, `"github"`,
#'   `"discord"`.
#' @param label Label; if omitted, uses a default text for the provider.
#' @param inputId If provided, clicks increment `input[[inputId]]` like
#'   [Button()].
#' @param ... Other props forwarded to [Button()] (`variant`, `size`, ...).
#' @export
SocialButton <- function(
  provider = c("google", "twitter", "facebook", "github", "discord"),
  label = NULL,
  inputId = NULL,
  ...
) {
  provider <- match.arg(provider)
  preset <- switch(
    provider,
    google = list(
      icon = IconBrandGoogle(size = 18),
      color = "red",
      variant = "default",
      defaultLabel = "Continue with Google"
    ),
    twitter = list(
      icon = IconBrandTwitter(size = 18),
      color = "cyan",
      variant = "filled",
      defaultLabel = "Follow on Twitter"
    ),
    facebook = list(
      icon = IconBrandFacebook(size = 18),
      color = "blue",
      variant = "filled",
      defaultLabel = "Log in with Facebook"
    ),
    github = list(
      icon = IconBrandGithub(size = 18),
      color = "dark",
      variant = "filled",
      defaultLabel = "Log in with GitHub"
    ),
    discord = list(
      icon = IconBrandDiscord(size = 18),
      color = "indigo",
      variant = "filled",
      defaultLabel = "Join on Discord"
    )
  )
  Button(
    label %||% preset$defaultLabel,
    inputId = inputId,
    leftSection = preset$icon,
    color = preset$color,
    variant = preset$variant,
    ...
  )
}

# Icons used by the components above (registered in js/src/index.js) ----------

#' @rdname icons
#' @export
IconSun <- displayComponent("IconSun")

#' @rdname icons
#' @export
IconMoon <- displayComponent("IconMoon")

#' @rdname icons
#' @export
IconCopy <- displayComponent("IconCopy")

#' @rdname icons
#' @export
IconCheck <- displayComponent("IconCheck")

#' @rdname icons
#' @export
IconBrandGoogle <- displayComponent("IconBrandGoogle")

#' @rdname icons
#' @export
IconBrandFacebook <- displayComponent("IconBrandFacebook")

#' @rdname icons
#' @export
IconBrandGithub <- displayComponent("IconBrandGithub")

#' @rdname icons
#' @export
IconBrandDiscord <- displayComponent("IconBrandDiscord")
