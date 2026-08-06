# Mantine DirectionProvider (RTL/LTR text direction)

Wrap
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)'s
children to set the reading direction for the whole app (`dir = "rtl"`
for Arabic/Hebrew, `"ltr"` otherwise).

## Usage

``` r
DirectionProvider(dir = "ltr", ...)
```

## Arguments

- dir:

  Either `"ltr"` or `"rtl"`.

- ...:

  Children.
