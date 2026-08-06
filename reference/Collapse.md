# Mantine Collapse (animated show/hide container)

Purely controlled by the app: toggle `opened` via
`updateMantineProps(session, mantineId, opened = TRUE/FALSE)` (Collapse
has no built-in trigger of its own — pair it with a
[`Button()`](https://coppertank.github.io/shiny.mantine/reference/Button.md)
whose
[`observeEvent()`](https://rdrr.io/pkg/shiny/man/observeEvent.html)
calls
[`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md)).

## Usage

``` r
Collapse(mantineId = NULL, opened = FALSE, ...)
```

## Arguments

- mantineId:

  Id used to control `opened` from R via
  [`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md).

- opened:

  Whether the content is expanded.

- ...:

  Children and other props (`transitionDuration`, ...). See
  <https://mantine.dev/core/collapse/>.

## Examples

``` r
if (FALSE) { # \dontrun{
Collapse(mantineId = "details", opened = FALSE, Text("Hidden content"))
# server:
observeEvent(input$toggle_btn, {
  updateMantineProps(session, "details", opened = !isTRUE(state$open))
})
} # }
```
