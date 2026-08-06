# Mantine Drawer.Root (fully custom drawer layout)

Same idea as
[`ModalRoot()`](https://coppertank.github.io/shiny.mantine/reference/ModalRoot.md),
for
[`Drawer()`](https://coppertank.github.io/shiny.mantine/reference/Drawer.md)
instead of
[`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md):
compose it with
[`DrawerOverlay()`](https://coppertank.github.io/shiny.mantine/reference/DrawerOverlay.md),
[`DrawerContent()`](https://coppertank.github.io/shiny.mantine/reference/DrawerContent.md),
[`DrawerHeader()`](https://coppertank.github.io/shiny.mantine/reference/DrawerHeader.md),
[`DrawerTitle()`](https://coppertank.github.io/shiny.mantine/reference/DrawerTitle.md),
[`DrawerCloseButton()`](https://coppertank.github.io/shiny.mantine/reference/DrawerCloseButton.md)
and
[`DrawerBody()`](https://coppertank.github.io/shiny.mantine/reference/DrawerBody.md).
Opens/closes from R exactly like
[`Drawer()`](https://coppertank.github.io/shiny.mantine/reference/Drawer.md),
including
[`DrawerStack()`](https://coppertank.github.io/shiny.mantine/reference/DrawerStack.md)
participation.

## Usage

``` r
DrawerRoot(mantineId, ..., inputId = NULL, opened = FALSE)
```

## Arguments

- mantineId:

  Identifier for
  [`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md).

- ...:

  Children — typically
  [`DrawerOverlay()`](https://coppertank.github.io/shiny.mantine/reference/DrawerOverlay.md)
  and
  [`DrawerContent()`](https://coppertank.github.io/shiny.mantine/reference/DrawerContent.md)
  (wrapping
  [`DrawerHeader()`](https://coppertank.github.io/shiny.mantine/reference/DrawerHeader.md)
  with
  [`DrawerTitle()`](https://coppertank.github.io/shiny.mantine/reference/DrawerTitle.md) +
  [`DrawerCloseButton()`](https://coppertank.github.io/shiny.mantine/reference/DrawerCloseButton.md),
  and
  [`DrawerBody()`](https://coppertank.github.io/shiny.mantine/reference/DrawerBody.md))
  — plus other props (`position`, `size`, ...). See
  <https://mantine.dev/core/drawer/#drawerroot>.

- inputId:

  If provided, receives `FALSE` when the user closes it.

- opened:

  Initial state.
