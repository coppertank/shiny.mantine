# Mantine multi-segment Progress (`Progress.Root`/`.Section`/`.Label`)

The compound form of
[`Progress()`](https://coppertank.github.io/shiny.mantine/reference/Progress.md),
for a single bar split into multiple colored segments (e.g. a stacked
disk-usage bar) — nest one `ProgressSection()` per segment (each with
its own `value`/`color`) inside `ProgressRoot()`; `ProgressLabel()`
renders text inside a section.

## Usage

``` r
ProgressRoot(...)

ProgressSection(...)

ProgressLabel(...)
```

## Arguments

- ...:

  Props and children. See
  <https://mantine.dev/core/progress/#multiple-sections>.

## Examples

``` r
if (FALSE) { # \dontrun{
ProgressRoot(
  size = "xl",
  ProgressSection(value = 35, color = "blue"),
  ProgressSection(value = 20, color = "orange"),
  ProgressSection(value = 15, color = "red")
)
} # }
```
