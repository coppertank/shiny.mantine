# Mantine SankeyChart (flow diagram)

`data` is a named list matching Mantine's shape directly:
`list(nodes = list(list(name = ...), ...), links = list(list(source = <index>, target = <index>, value = ...), ...))`
— `source`/`target` are 0-based indices into `nodes`.

## Usage

``` r
SankeyChart(data, ...)
```

## Arguments

- data:

  `list(nodes = ..., links = ...)`. See
  <https://mantine.dev/charts/sankey-chart/>.

- ...:

  Other props.

## Examples

``` r
if (FALSE) { # \dontrun{
SankeyChart(data = list(
  nodes = list(list(name = "A"), list(name = "B"), list(name = "C")),
  links = list(list(source = 0, target = 1, value = 10), list(source = 1, target = 2, value = 5))
))
} # }
```
