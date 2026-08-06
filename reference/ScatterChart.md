# Mantine ScatterChart (x/y scatter plot)

Unlike the other charts, `data` is a list of *series*, each with its own
nested points — pass it exactly in Mantine's shape (no automatic
`data.frame` conversion, since there is no single flat table to
convert).

## Usage

``` r
ScatterChart(data, dataKey, ...)
```

## Arguments

- data:

  List of
  `list(name = ..., color = ..., data = list(list(x = ..., y = ...), ...))`,
  one entry per series.

- dataKey:

  `list(x = "col", y = "col")` — the field names read from each point.

- ...:

  Other props. See <https://mantine.dev/charts/scatter-chart/>.

## Examples

``` r
if (FALSE) { # \dontrun{
ScatterChart(
  data = list(list(
    name = "Group A", color = "blue.5",
    data = list(list(age = 20, bmi = 22), list(age = 30, bmi = 25))
  )),
  dataKey = list(x = "age", y = "bmi")
)
} # }
```
