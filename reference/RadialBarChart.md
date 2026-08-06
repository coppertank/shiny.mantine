# Mantine RadialBarChart / BubbleChart

`RadialBarChart()` plots one value per row as a radial bar (`dataKey`
picks the value column; per-row `color` in `data` controls each bar's
color). `BubbleChart()` plots points sized by a third dimension —
`dataKey` is `list(x = "col", y = "col", z = "col")` (x/y position, z
-\> bubble size). Both accept `data` as a `data.frame` or list of rows.

## Usage

``` r
RadialBarChart(data, dataKey, ...)

BubbleChart(data, dataKey, ...)
```

## Arguments

- data:

  Chart data (`data.frame` or list of rows).

- dataKey:

  For `RadialBarChart()`, the value column name. For `BubbleChart()`,
  `list(x = ..., y = ..., z = ...)`.

- ...:

  Other props. See <https://mantine.dev/charts/radial-bar-chart/> /
  <https://mantine.dev/charts/bubble-chart/>.
