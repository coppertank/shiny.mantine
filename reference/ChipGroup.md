# Mantine Chip / ChipGroup (Shiny stateful input)

`Chip()` must be nested inside `ChipGroup()` — Mantine automatically
links each child `Chip()` to the group's state (single or multiple
selection depending on `multiple`).

## Usage

``` r
ChipGroup(inputId, ..., value = NULL, multiple = FALSE)

updateMantineChipGroup(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)

Chip(value, label = NULL, ...)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` is synced to the selection
  (a string, or a vector if `multiple = TRUE`).

- ...:

  Other props.

- value:

  Initial value of the group (for `ChipGroup()`) or the option's
  identifier (for `Chip()`).

- multiple:

  If `TRUE`, more than one `Chip()` can be selected at once and
  `input[[inputId]]` becomes a character vector.

- session:

  Session object passed to the Shiny server function.

- label:

  Text of the individual Chip.
