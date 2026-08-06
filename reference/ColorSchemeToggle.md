# Color scheme toggle

Icon button (sun/moon) that toggles the whole
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)'s
light/dark theme — uses Mantine's `useMantineColorScheme()` hook.

## Usage

``` r
ColorSchemeToggle(inputId = NULL, ...)
```

## Arguments

- inputId:

  If provided, every toggle sends the new theme (`"light"`/`"dark"`) to
  `input[[inputId]]`.

- ...:

  Other props forwarded to `ActionIcon` (`size`, `variant`, ...).
