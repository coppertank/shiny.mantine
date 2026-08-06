# Mantine Menu checkbox/radio items

`MenuCheckboxItem()` is an independently-controlled checkbox row inside
a dropdown menu (own `checked`/`value` — not exclusive, unlike radio
items). `MenuRadioItem()`/`MenuRadioGroup()` behave like
[`Radio()`](https://coppertank.github.io/shiny.mantine/reference/RadioGroup.md)/[`RadioGroup()`](https://coppertank.github.io/shiny.mantine/reference/RadioGroup.md):
nest raw `MenuRadioItem()` calls inside a
`MenuRadioGroup(inputId, ...)`.

## Usage

``` r
MenuCheckboxItem(inputId, label = NULL, value = FALSE, ...)

updateMantineMenuCheckboxItem(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)

MenuCheckboxGroup(...)

MenuRadioGroup(inputId, ..., value = NULL, label = NULL)

updateMantineMenuRadioGroup(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)

MenuRadioItem(value, label = NULL, ...)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` is synced to the checked
  state (a boolean).

- label:

  Item text.

- value:

  Initial checked state.

- ...:

  Other props.

- session:

  Session object passed to the Shiny server function.
