# Mantine Drawer (like Modal, but slides in from a screen edge)

Same pattern as
[`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md):
open/close from R with
`updateMantineProps(session, mantineId, opened = TRUE/FALSE)`.

## Usage

``` r
Drawer(mantineId, ..., inputId = NULL, opened = FALSE)
```

## Arguments

- mantineId:

  Identifier for
  [`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md).

- ...:

  Children and other props (`position`, `size`, `title`, ...). See
  <https://mantine.dev/core/drawer/>.

- inputId:

  If provided, receives `FALSE` on user close.

- opened:

  Initial state.
