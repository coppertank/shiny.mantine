# Core: Buttons

``` r

library(shiny)
library(shiny.mantine)
```

An R rewrite of the [“Buttons”
category](https://mantine.dev/core/button/) on mantine.dev/core. For the
*recipes* shown on
[ui.mantine.dev/category/buttons](https://ui.mantine.dev/category/buttons/)
(color scheme toggle, copy-to-clipboard, split button, …), see
[`ButtonWithMenu()`](https://coppertank.github.io/shiny.mantine/reference/ButtonWithMenu.md)/[`SplitButton()`](https://coppertank.github.io/shiny.mantine/reference/SplitButton.md)/[`SocialButton()`](https://coppertank.github.io/shiny.mantine/reference/SocialButton.md)/[`ColorSchemeToggle()`](https://coppertank.github.io/shiny.mantine/reference/ColorSchemeToggle.md)/
[`LoadingProgressButton()`](https://coppertank.github.io/shiny.mantine/reference/LoadingProgressButton.md)
in
[`vignette("extras")`](https://coppertank.github.io/shiny.mantine/articles/extras.md)
and the runnable `inst/examples/buttons-app.R` demo instead — those are
compositions on top of the plain components below, not separate
mantine.dev pages.

## Button

<https://mantine.dev/core/button/> — the standard button. `inputId`
makes it stateful like
[`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html):
`input[[inputId]]` is a click counter, incremented on every click (there
is no synced “value” otherwise, so there’s no `updateButton()`).

``` r

Button("Click me", inputId = "my_btn", variant = "filled", color = "blue", leftSection = IconPlus(size = 16))

# server:
observeEvent(input$my_btn, {
  message("Clicked ", input$my_btn, " times")
})
```

`Button.Group`
([`ButtonGroup()`](https://coppertank.github.io/shiny.mantine/reference/ButtonGroup.md))
visually joins several buttons together with shared borders;
[`ButtonGroupSection()`](https://coppertank.github.io/shiny.mantine/reference/ButtonGroupSection.md)
adds a non-interactive section (e.g. a label) between them:

``` r

ButtonGroup(
  Button("Day", inputId = "range_day"),
  ButtonGroupSection(Text("or", size = "xs")),
  Button("Week", inputId = "range_week")
)
```

## ActionIcon

<https://mantine.dev/core/action-icon/> — an icon-only button, same
click-counter semantics as
[`Button()`](https://coppertank.github.io/shiny.mantine/reference/Button.md).

``` r

ActionIcon(inputId = "like_btn", variant = "light", color = "red", IconHeart(size = 18))
```

`ActionIcon.Group`
([`ActionIconGroup()`](https://coppertank.github.io/shiny.mantine/reference/ActionIconGroup.md))
and
[`ActionIconGroupSection()`](https://coppertank.github.io/shiny.mantine/reference/ActionIconGroupSection.md)
work exactly like their `Button.Group` counterparts above.

## CloseButton

<https://mantine.dev/core/close-button/> — a small “x” icon button, used
throughout the package internally
(e.g. [`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md)’s
own close control) and available standalone for your own dismissible UI.

``` r

Group(Text("Dismissible notice"), CloseButton(inputId = "dismiss_btn", "aria-label" = "Dismiss"))
```

## CopyButton

<https://mantine.dev/core/copy-button/> — copies `value` to the
clipboard and shows a “Copied” state for a few seconds.

``` r

CopyButton(value = "https://mantine.dev", label = "Copy link", copiedLabel = "Copied!")
```

## FileButton

<https://mantine.dev/core/file-button/> — a button that opens the native
file picker on click. Like
[`FileInput()`](https://coppertank.github.io/shiny.mantine/reference/FileInput.md),
only file *metadata* (name/size/type) is reported to Shiny, never the
file content.

``` r

FileButton(inputId = "avatar_upload", label = "Upload avatar", accept = "image/*")
```

## UnstyledButton

<https://mantine.dev/core/unstyled-button/> — a `<button>` with all
default Mantine styling stripped, for building fully custom clickable
elements (e.g. a card that’s entirely clickable) while keeping proper
button semantics/accessibility. Purely a passthrough — pair it with
`mantineElement()`-level composition if you need click reporting beyond
what the components above already cover.

``` r

UnstyledButton(
  style = list(display = "block", width = "100%", padding = "12px", borderRadius = "8px"),
  Group(Avatar(radius = "xl"), Text("Custom clickable row"))
)
```

## Where to go next

- [`vignette("core-navigation")`](https://coppertank.github.io/shiny.mantine/articles/core-navigation.md)
  —
  [`NavLink()`](https://coppertank.github.io/shiny.mantine/reference/NavLink.md),
  [`Menu()`](https://coppertank.github.io/shiny.mantine/reference/Menu.md),
  [`Tabs()`](https://coppertank.github.io/shiny.mantine/reference/Tabs.md),
  and other click-driven navigation components.
- `inst/examples/buttons-app.R` — every recipe from
  [ui.mantine.dev/category/buttons](https://ui.mantine.dev/category/buttons/)
  reproduced end-to-end.
