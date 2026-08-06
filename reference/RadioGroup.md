# Mantine Radio / RadioGroup (Shiny stateful input)

`Radio()` must be nested inside `RadioGroup()` — Mantine automatically
links each child `Radio()` to the group's state, nothing else needed.

## Usage

``` r
RadioGroup(inputId, ..., value = NULL, label = NULL)

updateMantineRadioGroup(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)

Radio(value, label = NULL, ...)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` is synced to the selection.

- ...:

  Other props.

- value:

  Initial value of the group (for `RadioGroup()`) or the option's
  identifier (for `Radio()`).

- label:

  Group label (for `RadioGroup()`) or the individual option's label (for
  `Radio()`).

- session:

  Session object passed to the Shiny server function.
