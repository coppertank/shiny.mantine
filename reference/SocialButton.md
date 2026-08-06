# Social buttons

A preconfigured (icon + color) button for a common provider. Pure R code
on top of
[`Button()`](https://coppertank.github.io/shiny.mantine/reference/Button.md)
— copy and adapt it if you need a provider other than the ones included.

## Usage

``` r
SocialButton(
  provider = c("google", "twitter", "facebook", "github", "discord"),
  label = NULL,
  inputId = NULL,
  ...
)
```

## Arguments

- provider:

  One of `"google"`, `"twitter"`, `"facebook"`, `"github"`, `"discord"`.

- label:

  Label; if omitted, uses a default text for the provider.

- inputId:

  If provided, clicks increment `input[[inputId]]` like
  [`Button()`](https://coppertank.github.io/shiny.mantine/reference/Button.md).

- ...:

  Other props forwarded to
  [`Button()`](https://coppertank.github.io/shiny.mantine/reference/Button.md)
  (`variant`, `size`, ...).
