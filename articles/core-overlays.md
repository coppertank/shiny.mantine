# Core: Overlays

``` r

library(shiny)
library(shiny.mantine)
```

An R rewrite of the [“Overlays”
category](https://mantine.dev/core/modal/) on mantine.dev/core.
[`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md)/[`Drawer()`](https://coppertank.github.io/shiny.mantine/reference/Drawer.md)/[`Dialog()`](https://coppertank.github.io/shiny.mantine/reference/Dialog.md)/[`Popover()`](https://coppertank.github.io/shiny.mantine/reference/Popover.md)
are all controlled from R the same way: a required `mantineId`
identifies them for
[`updateMantineProps(session, mantineId, opened = TRUE/FALSE)`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md),
and an optional `inputId` receives `FALSE` when the user closes them
(click outside, Escape, the built-in close button).

## Modal

<https://mantine.dev/core/modal/> — a centered dialog with a dimmed
backdrop.

``` r

Stack(
  Button("Open", inputId = "open_btn"),
  Modal(
    mantineId = "demo_modal", inputId = "modal_state", title = "Demo",
    Text("Are you sure you want to continue?"),
    Button("Confirm", inputId = "confirm_btn")
  )
)

# server:
observeEvent(input$open_btn, {
  updateMantineProps(session, "demo_modal", opened = TRUE)
})
```

More than one
[`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md)
open at once needs
[`ModalStack()`](https://coppertank.github.io/shiny.mantine/reference/ModalStack.md)
instead of independent ones (they don’t otherwise coordinate
z-index/focus trapping):

``` r

ModalStack(
  mantineId = "delete_stack",
  Modal("delete_page", inputId = "delete_page_state", title = "Delete this page?",
    Button("Continue", inputId = "go_to_confirm")
  ),
  Modal("confirm_delete", title = "Are you really sure?",
    Button("Yes, delete", inputId = "confirm_delete_btn", color = "red")
  )
)
```

For full control over the internal layout, use the compound form —
[`ModalRoot()`](https://coppertank.github.io/shiny.mantine/reference/ModalRoot.md) +
[`ModalOverlay()`](https://coppertank.github.io/shiny.mantine/reference/ModalOverlay.md)/[`ModalContent()`](https://coppertank.github.io/shiny.mantine/reference/ModalContent.md)/[`ModalHeader()`](https://coppertank.github.io/shiny.mantine/reference/ModalHeader.md)/
[`ModalTitle()`](https://coppertank.github.io/shiny.mantine/reference/ModalTitle.md)/[`ModalCloseButton()`](https://coppertank.github.io/shiny.mantine/reference/ModalCloseButton.md)/[`ModalBody()`](https://coppertank.github.io/shiny.mantine/reference/ModalBody.md)
— which opens/closes exactly like
[`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md)
(and can join a
[`ModalStack()`](https://coppertank.github.io/shiny.mantine/reference/ModalStack.md)
too):

``` r

ModalRoot(
  "custom_modal", inputId = "custom_modal_state",
  ModalOverlay(),
  ModalContent(
    ModalHeader(ModalTitle("Custom layout"), ModalCloseButton()),
    ModalBody(Text("Modal content"))
  )
)
```

## Drawer

<https://mantine.dev/core/drawer/> — like
[`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md),
but slides in from a screen edge
(`position = "left"/"right"/"top"/"bottom"`). Same API, including
[`DrawerStack()`](https://coppertank.github.io/shiny.mantine/reference/DrawerStack.md)
and the
[`DrawerRoot()`](https://coppertank.github.io/shiny.mantine/reference/DrawerRoot.md)
compound form.

``` r

Drawer(mantineId = "settings_drawer", inputId = "drawer_state", title = "Settings", position = "right", Text("Drawer content"))
```

## Dialog

<https://mantine.dev/core/dialog/> — a small, non-modal overlay anchored
to a screen corner (no dimmed backdrop), for lightweight prompts.

``` r

Dialog(mantineId = "cookie_dialog", inputId = "cookie_state", opened = TRUE, Text("We use cookies."), Button("Accept", inputId = "accept_btn"))
```

## Popover

<https://mantine.dev/core/popover/> — a floating panel anchored to a
target element; compose with
[`PopoverTarget()`](https://coppertank.github.io/shiny.mantine/reference/Popover.md)/[`PopoverDropdown()`](https://coppertank.github.io/shiny.mantine/reference/Popover.md).
Use this specifically when you need to open/close it from R — for a
self-managed client-side dropdown,
[`HoverCard()`](https://coppertank.github.io/shiny.mantine/reference/HoverCard.md)/[`Menu()`](https://coppertank.github.io/shiny.mantine/reference/Menu.md)
below are simpler.

``` r

Popover(
  mantineId = "info_popover", inputId = "popover_state",
  PopoverTarget(Button("Info", inputId = "info_btn")),
  PopoverDropdown(Text("Extra information shown on click."))
)
```

## HoverCard

<https://mantine.dev/core/hover-card/> — a floating panel shown on hover
(not click); fully self-managed client-side, no `mantineId` needed.

``` r

HoverCard(
  HoverCardTarget(Anchor(href = "#", "@username")),
  HoverCardDropdown(Text("Preview shown on hover."))
)
```

## Tooltip

<https://mantine.dev/core/tooltip/> — a small label shown on hover;
[`TooltipFloating()`](https://coppertank.github.io/shiny.mantine/reference/TooltipFloating.md)
follows the cursor instead of anchoring to the target,
[`TooltipGroup()`](https://coppertank.github.io/shiny.mantine/reference/TooltipGroup.md)
shares open/close delay across several tooltips.

``` r

Tooltip(label = "Settings", ActionIcon(inputId = "settings_icon_btn", IconSettings(size = 18)))
```

## Menu

<https://mantine.dev/core/menu/> — a dropdown menu opened by clicking
its target; compose with
[`MenuTarget()`](https://coppertank.github.io/shiny.mantine/reference/Menu.md)/[`MenuDropdown()`](https://coppertank.github.io/shiny.mantine/reference/Menu.md)/[`menuItem()`](https://coppertank.github.io/shiny.mantine/reference/menuItem.md).
Also supports submenus
([`MenuSub()`](https://coppertank.github.io/shiny.mantine/reference/MenuSub.md)),
checkbox/radio items
([`MenuCheckboxItem()`](https://coppertank.github.io/shiny.mantine/reference/MenuCheckboxItem.md)/[`MenuRadioGroup()`](https://coppertank.github.io/shiny.mantine/reference/MenuCheckboxItem.md)),
an inline search
([`MenuSearch()`](https://coppertank.github.io/shiny.mantine/reference/MenuSearch.md)),
and a right-click context-menu variant
([`MenuContextMenu()`](https://coppertank.github.io/shiny.mantine/reference/MenuSearch.md)).

``` r

Menu(
  MenuTarget(Button("Actions", inputId = "menu_btn")),
  MenuDropdown(
    menuItem("action", "edit", "Edit", leftSection = IconEdit(size = 16)),
    MenuDivider(),
    menuItem("action", "delete", "Delete", leftSection = IconTrash(size = 16), color = "red")
  )
)
```

## Menubar

<https://mantine.dev/core/menubar/> — a desktop-app-style horizontal bar
of always-visible menus (File, Edit, View, …), distinct from a single
dropdown
[`Menu()`](https://coppertank.github.io/shiny.mantine/reference/Menu.md).

``` r

Menubar(
  MenubarMenu(
    MenubarTarget(Button("File", inputId = "file_menu_btn", variant = "subtle")),
    MenubarDropdown(menuItem("file_action", "new", "New"), menuItem("file_action", "open", "Open"))
  ),
  MenubarMenu(
    MenubarTarget(Button("Edit", inputId = "edit_menu_btn", variant = "subtle")),
    MenubarDropdown(menuItem("edit_action", "undo", "Undo"))
  )
)
```

## Affix

<https://mantine.dev/core/affix/> — fixed-position content (e.g. a “back
to top” button) that stays in place while the page scrolls.

``` r

Affix(position = list(bottom = 20, right = 20), Button("Back to top", inputId = "back_to_top_btn"))
```

## LoadingOverlay

<https://mantine.dev/core/loading-overlay/> — a full-cover spinner
overlay for a section of the page while it loads.

``` r

Box(
  pos = "relative", h = 200,
  LoadingOverlay(mantineId = "table_loading", visible = TRUE),
  Text("Content being loaded...")
)

# server:
observeEvent(input$data_ready, {
  updateMantineProps(session, "table_loading", visible = FALSE)
})
```

## Overlay

<https://mantine.dev/core/overlay/> — a semi-transparent layer over some
content, the building block
[`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md)/[`LoadingOverlay()`](https://coppertank.github.io/shiny.mantine/reference/LoadingOverlay.md)
use internally for the dimmed backdrop; available standalone for custom
overlays.

``` r

Box(pos = "relative", Image(src = "https://placehold.co/400x200"), Overlay(color = "#000", opacity = 0.6, zIndex = 1))
```

## FloatingWindow

<https://mantine.dev/core/floating-window/> — a draggable floating panel
positioned anywhere in the viewport by the user; `initialPosition` sets
where it starts (plain `list(top=, left=)`/`list(bottom=, right=)` data
— the window’s *live* position while being dragged isn’t
readable/settable from the server, since that needs a client-side ref).
Its parent needs `position: relative` (or similar) for the floating
window to be positioned against it.

``` r

Box(
  style = list(position = "relative", height = "300px"),
  FloatingWindow(
    initialPosition = list(top = 20, right = 20),
    style = list(border = "1px solid #ddd", background = "white", padding = "12px", width = 220),
    Text("Drag me by clicking and holding anywhere on me.")
  )
)
```

Add `dimensions` to make it resizable
(`list(initialWidth=, minWidth=, maxWidth=, initialHeight=, minHeight=, maxHeight=)`)
together with a
[`FloatingWindowResizeHandle()`](https://coppertank.github.io/shiny.mantine/reference/FloatingWindow.md)
child, typically pinned to a corner via `style`:

``` r

Box(
  style = list(position = "relative", height = "300px"),
  FloatingWindow(
    dimensions = list(initialWidth = 220, minWidth = 150, maxWidth = 400, initialHeight = 140, minHeight = 100, maxHeight = 300),
    style = list(border = "1px solid #ddd", background = "white", padding = "12px"),
    Text("Drag / resize me."),
    FloatingWindowResizeHandle(
      style = list(position = "absolute", right = 0, bottom = 0, cursor = "nwse-resize")
    )
  )
)
```

Set `inputId` to react to resizing server-side (added in Mantine 9.5.1):
`input[[inputId]]` holds the current `list(width=, height=)` after every
drag-resize, and `input[[paste0(inputId, "_resize_start")]]`/
`input[[paste0(inputId, "_resize_end")]]` fire as events when a
drag-resize begins/ends (not fired for keyboard resizing via the
handle). The window’s *position* is still not reported (see above).

``` r

FloatingWindow(
  inputId = "win_size",
  dimensions = list(initialWidth = 220, minWidth = 150, maxWidth = 400, initialHeight = 140, minHeight = 100, maxHeight = 300),
  Text("Resize me."),
  FloatingWindowResizeHandle(style = list(position = "absolute", right = 0, bottom = 0))
)
# server:
observe(print(input$win_size))  # list(width = ..., height = ...)
```

## FocusTrap / RemoveScroll

Not their own mantine.dev/core pages, but the two mechanisms
[`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md)/[`Drawer()`](https://coppertank.github.io/shiny.mantine/reference/Drawer.md)
use internally —
[`FocusTrap()`](https://coppertank.github.io/shiny.mantine/reference/FocusTrap.md)
keeps keyboard focus inside its child while `active`,
[`RemoveScroll()`](https://coppertank.github.io/shiny.mantine/reference/RemoveScroll.md)
locks page scrolling while `enabled` — exposed for building other fully
custom overlays that need the same behavior. See
[`vignette("core-misc")`](https://coppertank.github.io/shiny.mantine/articles/core-misc.md).

## FloatingArrow / FloatingIndicator (not wrapped)

Both need a live floating-UI `context` object and/or a target-element
`ref` to position themselves against another element — neither is a
plain, JSON-serializable R value, so they’re not wrapped.

## Where to go next

- [`vignette("core-misc")`](https://coppertank.github.io/shiny.mantine/articles/core-misc.md)
  —
  [`FocusTrap()`](https://coppertank.github.io/shiny.mantine/reference/FocusTrap.md),
  [`RemoveScroll()`](https://coppertank.github.io/shiny.mantine/reference/RemoveScroll.md),
  and other miscellaneous components.
- [`vignette("extras")`](https://coppertank.github.io/shiny.mantine/articles/extras.md)
  — group inputs, drag-and-drop reordering, and button recipes that
  don’t have their own mantine.dev/core page.
