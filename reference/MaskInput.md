# Mantine MaskInput (masked text input, e.g. phone numbers)

Mantine MaskInput (masked text input, e.g. phone numbers)

## Usage

``` r
MaskInput(inputId, mask, label = NULL, value = "", ...)

updateMantineMaskInput(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (the masked string) is
  synced on every keystroke.

- mask:

  Mask pattern (e.g. `"+1 (999) 999-9999"`; `9` = digit, `a`/`A` =
  lower/uppercase letter, `*` = alphanumeric — see
  <https://mantine.dev/core/mask-input/> for the full token list).

- label:

  Field label.

- value:

  Initial value.

- ...:

  Other props (`placeholder`, `description`, ...).

- session:

  Session object passed to the Shiny server function.
