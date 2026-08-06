# Mantine TimeValue (formats a time string/Date for display)

Purely a display component (not a Shiny input) — renders `value`
formatted as 12h/24h time, e.g. inside a
[`Text()`](https://coppertank.github.io/shiny.mantine/reference/Text.md).

## Usage

``` r
TimeValue(value, ...)
```

## Arguments

- value:

  Time to format: a `"HH:mm:ss"` string, or a `Date`/`POSIXct`.

- ...:

  Other props (`format` = `"12h"`/`"24h"`, `withSeconds`, `amPmLabels`,
  ...). See <https://mantine.dev/dates/time-value/>.

## Examples

``` r
if (FALSE) { # \dontrun{
TimeValue(value = "18:45:34", format = "12h")
} # }
```
