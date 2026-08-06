# Imperative modals (`@mantine/modals`)

Imperative API to open modals (confirmation or generic) from a single
server-side call, without having to declare a
[`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md)
in the UI ahead of time. Only supports simple props (no nested Mantine
component trees: for a modal with rich Mantine content, compose
[`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md)
with
[`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md)
instead).

## Usage

``` r
ModalsProvider(...)
```

## Arguments

- ...:

  Children and props (`ModalsProvider()`); see
  <https://mantine.dev/x/modals/>.

## Details

Requires `ModalsProvider()` mounted **once** in the page, wrapping the
content (like
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)).

## Examples

``` r
if (FALSE) { # \dontrun{
# ui:
MantineProvider(ModalsProvider(...))

# server:
observeEvent(input$delete_btn, {
  openMantineConfirmModal(
    session, inputId = "confirm_delete",
    title = "Confirm deletion",
    children = "This action cannot be undone. Continue?",
    labels = list(confirm = "Delete", cancel = "Cancel"),
    confirmProps = list(color = "red")
  )
})
observeEvent(input$confirm_delete, {
  if (isTRUE(input$confirm_delete)) {
    # ... actually delete ...
  }
})
} # }
```
