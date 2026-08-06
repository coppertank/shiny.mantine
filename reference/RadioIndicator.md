# Mantine RadioIndicator / CheckboxIndicator (standalone, decorative)

The visual "checked" indicator
[`Radio()`](https://coppertank.github.io/shiny.mantine/reference/RadioGroup.md)/[`Checkbox()`](https://coppertank.github.io/shiny.mantine/reference/Checkbox.md)
render internally, usable on its own wherever you need the same look
without a real input behind it — e.g. a read-only status list, or a
custom row that toggles some other way. Purely decorative: `checked`/
`indeterminate` are plain display props, not synced with Shiny (pair
with
[`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md)
if you need to change them from the server).

## Usage

``` r
RadioIndicator(checked = FALSE, ...)

CheckboxIndicator(checked = FALSE, indeterminate = FALSE, ...)
```

## Arguments

- checked:

  Whether to show the checked state.

- ...:

  Other props (`color`, `size`, `radius`, ...). See
  <https://mantine.dev/core/radio/#radioindicator>.

- indeterminate:

  Shows the indeterminate state (ignores `checked`).
