# Mantine CheckboxCard / RadioCard (card-styled selectable items)

Visually a bordered, clickable card instead of a small checkbox/radio
circle. Like
[`Chip()`](https://coppertank.github.io/shiny.mantine/reference/ChipGroup.md)/[`Radio()`](https://coppertank.github.io/shiny.mantine/reference/RadioGroup.md),
these are raw (unwrapped) so they can be nested inside
[`CheckboxGroup()`](https://coppertank.github.io/shiny.mantine/reference/CheckboxGroup.md)/[`RadioGroup()`](https://coppertank.github.io/shiny.mantine/reference/RadioGroup.md)
(Mantine's group context manages their checked state), or composed
standalone with your own `checked`/`onClick` via `mantineElement()`.

## Usage

``` r
CheckboxCard(...)

RadioCard(...)
```

## Arguments

- ...:

  Props and children. See
  <https://mantine.dev/core/checkbox/#checkboxcard>.
