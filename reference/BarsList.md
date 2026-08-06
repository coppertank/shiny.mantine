# Mantine BarsList (list of horizontal bars with names and values)

Mantine BarsList (list of horizontal bars with names and values)

## Usage

``` r
BarsList(data, ...)
```

## Arguments

- data:

  A `data.frame` (or list of rows) with `name` and `value` columns.

- ...:

  Other props (`barsLabel`, `valueLabel`, `barGap`, `minBarSize`,
  `barHeight`, ...). See <https://mantine.dev/charts/bars-list/>.

## Examples

``` r
if (FALSE) { # \dontrun{
BarsList(data = data.frame(
  name = c("React", "Vue", "Angular"),
  value = c(950000, 320000, 580000)
))
} # }
```
