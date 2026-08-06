# Copy to clipboard button

Copies `value` to the clipboard and shows "Copied" for a few moments
(uses Mantine's real `CopyButton` internally).

## Usage

``` r
CopyButton(value, label = "Copy", copiedLabel = "Copied", inputId = NULL, ...)
```

## Arguments

- value:

  Text to copy.

- label:

  Label before copying.

- copiedLabel:

  Label shown right after copying.

- inputId:

  If provided, every copy sends `value` to `input[[inputId]]` (useful to
  know server-side what was copied).

- ...:

  Other props forwarded to the underlying `Button` (`variant`, `size`,
  ...).
