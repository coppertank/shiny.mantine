# Mantine BulletChart (compact KPI chart: value vs. target vs. ranges)

Mantine BulletChart (compact KPI chart: value vs. target vs. ranges)

## Usage

``` r
BulletChart(value, ranges, ...)
```

## Arguments

- value:

  The actual value to display.

- ranges:

  Qualitative performance ranges: a `data.frame` (or list of rows) with
  `value` (the range's upper bound) and `color` columns, and optionally
  `label` — ordered smallest to largest (Mantine renders them
  back-to-front, largest first).

- ...:

  Other props (`target`, `label`, `orientation`, `size`, `barSize`,
  `barColor`, `targetColor`, `withTooltip`, `h` — required for
  `orientation = "vertical"`, ...). See
  <https://mantine.dev/charts/bullet-chart/>.

## Examples

``` r
if (FALSE) { # \dontrun{
BulletChart(
  value = 260000,
  target = 275000,
  label = "Revenue",
  ranges = data.frame(
    value = c(150000, 225000, 300000),
    color = c("red.8", "yellow.8", "teal.8"),
    label = c("Poor", "Average", "Good")
  )
)
} # }
```
