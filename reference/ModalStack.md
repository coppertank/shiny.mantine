# Mantine Modal.Stack (coordinated stack of Modal()s)

A standalone
[`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md)
only ever manages its own `opened` boolean, so having more than one open
at the same time (e.g. a confirmation modal opening another, more
specific one on top) doesn't layer/animate correctly — each mounts its
own independent overlay and focus trap, competing rather than
coordinating. Wrapping the same
[`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md)s
in `ModalStack()` instead delegates them to Mantine's own stack
controller, which handles z-index layering, the background-modal scale
effect, focus trapping and Escape-key handling between them.

## Usage

``` r
ModalStack(...)
```

## Arguments

- ...:

  [`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md)
  children (each needs its own `mantineId`, as usual), plus an optional
  `mantineId` of its own: if provided, lets you close every modal in the
  stack at once from R with
  `updateMantineProps(session, mantineId, closeAll = TRUE)`. See
  <https://mantine.dev/core/modal/#stacked-modals>.

## Details

Every child
[`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md)
keeps working exactly as documented there —
`updateMantineProps(session, mantineId, opened = TRUE/FALSE)` still
opens/closes it, and `inputId` still receives `FALSE` on user close.
Being nested inside a `ModalStack()` is enough to switch a
[`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md)
to coordinated stack behavior; no other change is needed on the R side.

## Examples

``` r
if (FALSE) { # \dontrun{
# ui:
ModalStack(
  mantineId = "delete_stack",
  Modal("delete_page", title = "Delete this page?",
    Text("This can be undone later from the trash."),
    Button("Continue", inputId = "go_to_confirm")
  ),
  Modal("confirm_delete", title = "Are you really sure?",
    Button("Yes, delete", inputId = "confirm_delete_btn", color = "red")
  )
)

# server:
observeEvent(input$go_to_confirm, {
  updateMantineProps(session, "confirm_delete", opened = TRUE)
})
observeEvent(input$confirm_delete_btn, {
  updateMantineProps(session, "delete_stack", closeAll = TRUE)
})
} # }
```
