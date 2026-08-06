# Mantine Pagination (Shiny stateful input)

Mantine Pagination (Shiny stateful input)

## Usage

``` r
Pagination(inputId, total, value = 1, ...)

updateMantinePagination(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` is synced on page change.

- total:

  Total number of pages.

- value:

  Initial page.

- ...:

  Other props (`siblings`, `boundaries`, ...). See
  <https://mantine.dev/core/pagination/>.

- session:

  Session object passed to the Shiny server function.
