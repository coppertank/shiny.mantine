# Mantine SunburstChart (hierarchical concentric-rings chart)

`data` is a nested list matching Mantine's shape directly (no automatic
`data.frame` conversion, like
[`Treemap()`](https://coppertank.github.io/shiny.mantine/reference/Treemap.md)/[`SankeyChart()`](https://coppertank.github.io/shiny.mantine/reference/SankeyChart.md)):
a list of `list(name=, value=, color=, children=...)`. Leaf nodes need
`value`; parent nodes nest further options under `children` instead.
Every node needs `name`/`color`; children inherit their parent's color
if omitted.

## Usage

``` r
SunburstChart(data, ...)
```

## Arguments

- data:

  Nested list of chart nodes. See
  <https://mantine.dev/charts/sunburst-chart/>.

- ...:

  Other props (`size`, `withLabels`, `withTooltip`, `gap`,
  `strokeColor`, ...).

## Examples

``` r
if (FALSE) { # \dontrun{
SunburstChart(data = list(
  list(name = "Frontend", color = "blue.6", children = list(
    list(name = "React", value = 400),
    list(name = "Vue", value = 200)
  )),
  list(name = "Backend", value = 500, color = "red.6")
))
} # }
```
