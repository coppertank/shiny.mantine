# Mantine Treemap (hierarchical rectangles chart)

`data` is a nested list matching Mantine's shape directly (no automatic
conversion): a list of
`list(name = ..., value = ..., color = ..., ...)`, optionally with a
nested `children` list per node for hierarchy.

## Usage

``` r
Treemap(data, ...)
```

## Arguments

- data:

  Nested list of chart nodes. See <https://mantine.dev/charts/treemap/>.

- ...:

  Other props (`h`, `withTooltip`, `colorAlpha`, ...).
