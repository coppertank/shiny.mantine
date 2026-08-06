# Mantine Button (stateless / action button)

Every click increments `input[[inputId]]`, exactly like
[`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html):
use it with `observeEvent(input[[inputId]], ...)`. The button keeps no
synced local value (unlike
[`TextInput()`](https://coppertank.github.io/shiny.mantine/reference/TextInput.md))
— it only reports a click counter — which is why there is no
`updateButton()`.

## Usage

``` r
Button(label, inputId, ...)
```

## Arguments

- label:

  Button label (text or nested content).

- inputId:

  Id of the Shiny input incremented on every click.

- ...:

  Other props forwarded to Mantine's `Button` component (`variant`,
  `color`, `size`, `leftSection`, `disabled`, ...). See
  <https://mantine.dev/core/button/>.
