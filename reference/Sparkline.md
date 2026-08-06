# Mantine Sparkline (small inline chart)

Mantine Sparkline (small inline chart)

## Usage

``` r
Sparkline(data, ...)
```

## Arguments

- data:

  A plain numeric vector (or list with `NA`/`NULL` gaps), one point per
  value — not a `data.frame` (there are no separate fields to pick a
  column from).

- ...:

  Other props (`color`, `trendColors`, `curveType`, `w`, `h`, ...). See
  <https://mantine.dev/charts/sparkline/>.

## Examples

``` r
if (FALSE) { # \dontrun{
Sparkline(data = c(10, 25, 15, 30, 22, 40), color = "blue", h = 40)
} # }
```
