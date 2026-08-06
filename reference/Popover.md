# Mantine Popover (controlled) and primitives

For a self-managed client-side dropdown (no control from R needed) use
[`HoverCard()`](https://coppertank.github.io/shiny.mantine/reference/HoverCard.md)/[`Menu()`](https://coppertank.github.io/shiny.mantine/reference/Menu.md).
Use `Popover()` with `mantineId` only if you need to explicitly
open/close it from R.

## Usage

``` r
Popover(mantineId, ..., inputId = NULL, opened = FALSE)

PopoverTarget(...)

PopoverDropdown(...)
```

## Arguments

- mantineId:

  Identifier for
  [`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md).

- ...:

  Children (usually `PopoverTarget()` + `PopoverDropdown()`) and other
  props. See <https://mantine.dev/core/popover/>.

- inputId:

  If provided, receives `FALSE` on user close.

- opened:

  Initial state.
