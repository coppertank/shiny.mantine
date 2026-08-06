# Mantine Drawer.Stack (coordinated stack of Drawer()s)

Same idea and API as
[`ModalStack()`](https://coppertank.github.io/shiny.mantine/reference/ModalStack.md),
for
[`Drawer()`](https://coppertank.github.io/shiny.mantine/reference/Drawer.md)
instead of
[`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md):
wrap several
[`Drawer()`](https://coppertank.github.io/shiny.mantine/reference/Drawer.md)s
that may be open at the same time in `DrawerStack()` so Mantine
coordinates z-index, focus trapping and Escape-key handling between
them, instead of each managing its `opened` state independently.

## Usage

``` r
DrawerStack(...)
```

## Arguments

- ...:

  [`Drawer()`](https://coppertank.github.io/shiny.mantine/reference/Drawer.md)
  children (each needs its own `mantineId`, as usual), plus an optional
  `mantineId` of its own: if provided, lets you close every drawer in
  the stack at once from R with
  `updateMantineProps(session, mantineId, closeAll = TRUE)`. See
  <https://mantine.dev/core/drawer/#stacked-drawers>.
