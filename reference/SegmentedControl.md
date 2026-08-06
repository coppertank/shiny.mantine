# Mantine SegmentedControl (Shiny stateful input)

Mantine SegmentedControl (Shiny stateful input)

## Usage

``` r
SegmentedControl(inputId, data, value = NULL, ...)

updateMantineSegmentedControl(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` is synced on every
  selection.

- data:

  Vector or list of options (`value`/`label`). See
  <https://mantine.dev/core/segmented-control/>.

- value:

  Initial value.

- ...:

  Other props (`color`, `fullWidth`, ...).

- session:

  Session object passed to the Shiny server function.
