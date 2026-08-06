# Mantine Switch (Shiny stateful boolean input)

Mantine Switch (Shiny stateful boolean input)

## Usage

``` r
Switch(inputId, label = NULL, value = FALSE, ...)

updateMantineSwitch(
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

  Other props (`description`, `color`, `size`, `disabled`, ...). See
  <https://mantine.dev/core/switch/>.

- session:

  Session object passed to the Shiny server function.
