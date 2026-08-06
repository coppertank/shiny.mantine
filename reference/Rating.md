# Mantine Rating (Shiny stateful input)

Mantine Rating (Shiny stateful input)

## Usage

``` r
Rating(inputId, value = 0, ...)

updateMantineRating(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` is synced to the selection.

- value:

  Initial value.

- ...:

  Other props (`count`, `fractions`, `color`, ...). See
  <https://mantine.dev/core/rating/>.

- session:

  Session object passed to the Shiny server function.
