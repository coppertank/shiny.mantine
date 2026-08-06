# MantineProvider

Provides 'Mantine's theme/spacing/color context, including the
light/dark color scheme. Every 'shiny.mantine' component must sit,
directly or indirectly, inside a single `MantineProvider()` call:
Mantine components used outside a provider will not render correctly
(missing theme/CSS variables).

## Usage

``` r
MantineProvider(
  ...,
  defaultColorScheme = c("light", "dark", "auto"),
  theme = NULL,
  containerId = NULL,
  fixShinyFontScale = TRUE
)
```

## Arguments

- ...:

  'shiny.mantine' components (e.g.
  [`Button()`](https://coppertank.github.io/shiny.mantine/reference/Button.md),
  [`TextInput()`](https://coppertank.github.io/shiny.mantine/reference/TextInput.md))
  and/or plain 'htmltools' tags to render as children. Plain 'htmltools'
  tags (e.g. `tags$h2()`) are rendered as static markup. Do not nest
  [`shiny::textOutput()`](https://rdrr.io/pkg/shiny/man/textOutput.html)
  or other native Shiny bindings here: the content is inserted via
  `dangerouslySetInnerHTML` and Shiny does not automatically re-scan it
  for bindings. Put native Shiny outputs/inputs outside
  `MantineProvider()`.

- defaultColorScheme:

  One of `"light"`, `"dark"`, `"auto"`.

- theme:

  A list overriding Mantine's default theme (colors, fonts, spacing,
  ...). See <https://mantine.dev/theming/theme-object/>. If
  `theme$scale` is not set and `fixShinyFontScale` is `TRUE` (the
  default), it is computed automatically at mount time — see
  `fixShinyFontScale`.

- containerId:

  Fixed HTML id for the mount point. Generated automatically if omitted.

- fixShinyFontScale:

  Shiny's bundled Bootstrap 3 CSS (attached by
  [`fluidPage()`](https://rdrr.io/pkg/shiny/man/fluidPage.html)/[`bootstrapPage()`](https://rdrr.io/pkg/shiny/man/bootstrapPage.html),
  but *not* by a plain
  [`tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html)
  UI) sets `html { font-size: 10px; }`, while Mantine's entire size
  scale (font sizes, spacing, component dimensions) is expressed in
  `rem` units calibrated for the browser default of a 16px root — so
  under a 10px root every Mantine component renders at 62.5% of its
  intended size, and conversely a blindly-applied fix would
  *over*-correct on pages whose root really is 16px (e.g.
  [`tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html)-based
  UIs, which don't load Bootstrap at all). Since the actual root
  font-size depends entirely on which page function and CSS the
  surrounding app happens to load — something R has no way to know ahead
  of time — this can't be fixed with a fixed guess baked in on the R
  side. Instead, when `TRUE` (the default), the JS side measures the
  real, already-computed root font-size once at mount time and sets
  `theme$scale <- 16 / <measured px>` via Mantine's own built-in
  `--mantine-scale` mechanism — correct whether the actual root is 10px,
  16px, or anything else (e.g. a browser accessibility "larger text"
  setting). Set to `FALSE` to get Mantine's untouched default sizing, or
  supply your own `theme$scale` to take over the calculation yourself
  (either disables auto-detection).

## Value

A `shiny.tag.list` to insert into a Shiny app's UI.
