# Mantine SwitchGroup (multi-selection input, Shiny stateful)

Same relationship as
[`CheckboxGroup()`](https://coppertank.github.io/shiny.mantine/reference/CheckboxGroup.md)/[`CheckboxGroupItem()`](https://coppertank.github.io/shiny.mantine/reference/CheckboxGroup.md),
but with `Switch`-styled toggles instead of checkboxes.

## Usage

``` r
SwitchGroup(inputId, ..., value = list(), label = NULL)

updateMantineSwitchGroup(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)

SwitchGroupItem(value, label = NULL, ...)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (a character vector) is
  synced on every change.

- ...:

  `SwitchGroupItem()` children and other props.

- value:

  The value identifying this switch within the group.

- label:

  Group label.

- session:

  Session object passed to the Shiny server function.
