# Mantine Dialog (small non-modal overlay, screen corner)

Same pattern as
[`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md):
open/close from R with
`updateMantineProps(session, mantineId, opened = TRUE/FALSE)`.

## Usage

``` r
Dialog(mantineId, ..., inputId = NULL, opened = FALSE)
```

## Arguments

- mantineId:

  Identifier for
  [`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md).

- ...:

  Children and other props (`position`, `size`, ...). See
  <https://mantine.dev/core/dialog/>.

- inputId:

  If provided, receives `FALSE` on user close.

- opened:

  Initial state.
