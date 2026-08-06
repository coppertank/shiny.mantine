# Mantine CheckboxGroup (multi-selection input, Shiny stateful)

`CheckboxGroupItem()` must be used for the children (not the standalone
[`Checkbox()`](https://coppertank.github.io/shiny.mantine/reference/Checkbox.md),
which owns its own checked state) — Mantine's group context derives each
item's checked state from its `value` against the group's array `value`,
the same relationship
[`RadioGroup()`](https://coppertank.github.io/shiny.mantine/reference/RadioGroup.md)/[`Radio()`](https://coppertank.github.io/shiny.mantine/reference/RadioGroup.md)
and
[`ChipGroup()`](https://coppertank.github.io/shiny.mantine/reference/ChipGroup.md)/[`Chip()`](https://coppertank.github.io/shiny.mantine/reference/ChipGroup.md)
already have in this package.

## Usage

``` r
CheckboxGroup(inputId, ..., value = list(), label = NULL)

updateMantineCheckboxGroup(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)

CheckboxGroupItem(value, label = NULL, ...)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (a character vector) is
  synced on every change.

- ...:

  `CheckboxGroupItem()` children and other props.

- value:

  The value identifying this checkbox within the group.

- label:

  Group label.

- session:

  Session object passed to the Shiny server function.
