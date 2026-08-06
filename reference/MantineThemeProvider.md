# Mantine MantineThemeProvider

Updates the theme object exposed via Mantine's useMantineTheme() hook
for custom code - does NOT restyle standard components, see the note in
`?MantineThemeProvider`. Supports `mantineId` for reactive updates via
[`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md).

## Usage

``` r
MantineThemeProvider(...)
```

## Arguments

- ...:

  Props and children. See <https://mantine.dev/core/mantine-provider/>.
