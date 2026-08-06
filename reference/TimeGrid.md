# Mantine TimeGrid (Shiny stateful input, grid of selectable time slots)

Mantine TimeGrid (Shiny stateful input, grid of selectable time slots)

## Usage

``` r
TimeGrid(inputId, data, value = NULL, ...)

updateMantineTimeGrid(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (a `"HH:mm"` string, or
  `NULL`) is synced on selection.

- data:

  A character vector of selectable times (e.g.
  `c("09:00", "09:30", "10:00")`).

- value:

  Initial value.

- ...:

  Other props (`format`, `simpleGridProps`, ...). See
  <https://mantine.dev/dates/time-grid/>.

- session:

  Session object passed to the Shiny server function.
