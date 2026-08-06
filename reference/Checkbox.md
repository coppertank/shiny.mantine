# Mantine Checkbox (Shiny stateful boolean input)

Mantine Checkbox (Shiny stateful boolean input)

## Usage

``` r
Checkbox(inputId, label = NULL, value = FALSE, ...)

updateMantineCheckbox(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (`TRUE`/`FALSE`) is synced
  on every toggle.

- label:

  Field label.

- value:

  Initial value.

- ...:

  Other props (`description`, `color`, `size`, ...). See
  <https://mantine.dev/core/checkbox/>.

- session:

  Session object passed to the Shiny server function.
