# Mantine Modal

Open/close from R with
`updateMantineProps(session, mantineId, opened = TRUE/FALSE)`. When the
user closes it (X, click outside, Escape), `input[[inputId]]` (if
provided) receives `FALSE`.

## Usage

``` r
Modal(mantineId, ..., inputId = NULL, opened = FALSE)
```

## Arguments

- mantineId:

  Identifier for
  [`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md)
  (opening/closing from R). Required: without it, the Modal cannot be
  controlled from R (it would stay in its initial `opened` state).

- ...:

  Children (the modal's content) and other props (`title`, `size`,
  `centered`, ...). See <https://mantine.dev/core/modal/>.

- inputId:

  If provided, receives `FALSE` when the user closes the modal.

- opened:

  Initial state (usually `FALSE`: opened from R at the right moment with
  [`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md)).

## Examples

``` r
if (FALSE) { # \dontrun{
# ui:
Modal("confirm_modal", inputId = "confirm_modal_state", title = "Confirm",
  Text("Are you sure?"),
  Button("Confirm", inputId = "confirm_btn")
)
Button("Open modal", inputId = "open_modal_btn")

# server:
observeEvent(input$open_modal_btn, {
  updateMantineProps(session, "confirm_modal", opened = TRUE)
})
observeEvent(input$confirm_btn, {
  updateMantineProps(session, "confirm_modal", opened = FALSE)
})
} # }
```
