# Mantine PieChart / DonutChart (pie/donut charts)

`data` is a `data.frame` (or list of rows) with columns `name`, `value`,
and optionally `color`.

## Usage

``` r
PieChart(data, ...)

DonutChart(data, ...)
```

## Arguments

- data:

  Chart data (`data.frame` or list of rows, with
  `name`/`value`/`color`).

- ...:

  Other props (`withLabels`, `withTooltip`, `size`, ...). See
  <https://mantine.dev/charts/pie-chart/>.

## Examples

``` r
if (FALSE) { # \dontrun{
PieChart(data = data.frame(
  name = c("A", "B", "C"),
  value = c(40, 35, 25),
  color = c("blue.6", "orange.6", "grape.6")
))
} # }
```
