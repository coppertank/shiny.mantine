# Mantine LineChart / BarChart / AreaChart (multi-series charts)

`data` can be a `data.frame` (one row per point/category, one column per
field — converted automatically) or a list of
[`list()`](https://rdrr.io/r/base/list.html)s with the same structure.
`series` indicates which columns to draw: a list of
`list(name = "column", color = "blue.6")`.

## Usage

``` r
LineChart(data, series, ...)

BarChart(data, series, ...)

AreaChart(data, series, ...)
```

## Arguments

- data:

  Chart data (`data.frame` or list of rows).

- series:

  List of `list(name = ..., color = ...)`, one per series.

- ...:

  Other props (`dataKey`, `curveType`, `withLegend`, `withTooltip`,
  ...). See <https://mantine.dev/charts/line-chart/>.

## Examples

``` r
if (FALSE) { # \dontrun{
LineChart(
  data = data.frame(month = c("Jan", "Feb", "Mar"), sales = c(120, 150, 90)),
  dataKey = "month",
  series = list(list(name = "sales", color = "blue.6"))
)
} # }
```
