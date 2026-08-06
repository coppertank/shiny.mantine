# Mantine Heatmap (calendar-style heatmap)

Mantine Heatmap (calendar-style heatmap)

## Usage

``` r
Heatmap(data, startDate = NULL, endDate = NULL, ...)
```

## Arguments

- data:

  A *named* list, not a `data.frame`: names are `"YYYY-MM-DD"` date
  strings, values are the numeric intensity for that day (e.g.
  `list("2024-01-01" = 5, "2024-01-02" = 12)`).

- startDate, endDate:

  Range shown, as `"YYYY-MM-DD"` strings or R `Date`/`POSIXct` values
  (converted automatically).

- ...:

  Other props (`colors`, `withTooltip`, `withWeekdayLabels`, ...). See
  <https://mantine.dev/charts/heatmap/>.

## Examples

``` r
if (FALSE) { # \dontrun{
Heatmap(
  data = list("2024-01-01" = 5, "2024-01-05" = 12, "2024-01-12" = 8),
  startDate = "2024-01-01", endDate = "2024-03-31"
)
} # }
```
