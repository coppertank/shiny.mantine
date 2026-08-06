# Mantine RadarChart / CompositeChart (multi-series charts)

`RadarChart()` plots one or more series across radial axes (`dataKey`
picks the column used for axis labels). `CompositeChart()` is like
[`LineChart()`](https://coppertank.github.io/shiny.mantine/reference/LineChart.md)/[`BarChart()`](https://coppertank.github.io/shiny.mantine/reference/LineChart.md)/[`AreaChart()`](https://coppertank.github.io/shiny.mantine/reference/LineChart.md)
but each series in `series` can set its own `type`
(`"line"`/`"bar"`/`"area"`), combining them in one chart. Both accept
`data` as a `data.frame` or list of rows, same as
[`LineChart()`](https://coppertank.github.io/shiny.mantine/reference/LineChart.md).

## Usage

``` r
RadarChart(data, series, dataKey, ...)

CompositeChart(data, series, ...)
```

## Arguments

- data:

  Chart data (`data.frame` or list of rows).

- series:

  List of `list(name = ..., color = ...)` (`CompositeChart()` series can
  also set `type = "line"/"bar"/"area"`).

- dataKey:

  Column used for radar axis labels.

- ...:

  Other props. See <https://mantine.dev/charts/radar-chart/> /
  <https://mantine.dev/charts/composite-chart/>.
