# Mantine Modal.Root (fully custom modal layout)

The lower-level piece behind
[`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md),
for full control over the modal's internal layout (e.g. extra controls
next to the title, a non-standard body/footer arrangement) — compose it
with
[`ModalOverlay()`](https://coppertank.github.io/shiny.mantine/reference/ModalOverlay.md),
[`ModalContent()`](https://coppertank.github.io/shiny.mantine/reference/ModalContent.md),
[`ModalHeader()`](https://coppertank.github.io/shiny.mantine/reference/ModalHeader.md),
[`ModalTitle()`](https://coppertank.github.io/shiny.mantine/reference/ModalTitle.md),
[`ModalCloseButton()`](https://coppertank.github.io/shiny.mantine/reference/ModalCloseButton.md)
and
[`ModalBody()`](https://coppertank.github.io/shiny.mantine/reference/ModalBody.md).
Opens/closes from R exactly like
[`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md)
(`updateMantineProps(session, mantineId, opened = TRUE/FALSE)`),
including
[`ModalStack()`](https://coppertank.github.io/shiny.mantine/reference/ModalStack.md)
participation if nested inside one — the compound and all-in-one forms
are interchangeable from R's point of view.

## Usage

``` r
ModalRoot(mantineId, ..., inputId = NULL, opened = FALSE)
```

## Arguments

- mantineId:

  Identifier for
  [`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md).

- ...:

  Children — typically
  [`ModalOverlay()`](https://coppertank.github.io/shiny.mantine/reference/ModalOverlay.md)
  and
  [`ModalContent()`](https://coppertank.github.io/shiny.mantine/reference/ModalContent.md)
  (wrapping
  [`ModalHeader()`](https://coppertank.github.io/shiny.mantine/reference/ModalHeader.md)
  with
  [`ModalTitle()`](https://coppertank.github.io/shiny.mantine/reference/ModalTitle.md) +
  [`ModalCloseButton()`](https://coppertank.github.io/shiny.mantine/reference/ModalCloseButton.md),
  and
  [`ModalBody()`](https://coppertank.github.io/shiny.mantine/reference/ModalBody.md))
  — plus other props (`size`, `centered`, `fullScreen`, ...). See
  <https://mantine.dev/core/modal/#modalroot>.

- inputId:

  If provided, receives `FALSE` when the user closes it.

- opened:

  Initial state.

## Examples

``` r
if (FALSE) { # \dontrun{
ModalRoot("custom_modal", inputId = "custom_modal_state",
  ModalOverlay(),
  ModalContent(
    ModalHeader(ModalTitle("Custom layout"), ModalCloseButton()),
    ModalBody(Text("Modal content"))
  )
)
} # }
```
