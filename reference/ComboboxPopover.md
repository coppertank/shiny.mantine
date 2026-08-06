# Mantine ComboboxPopover (dropdown-select attached to any custom target)

Like
[`Select()`](https://coppertank.github.io/shiny.mantine/reference/Select.md),
but renders no input of its own — supply the clickable target (e.g. a
[`Button()`](https://coppertank.github.io/shiny.mantine/reference/Button.md))
via `ComboboxPopoverTarget()`. `input[[inputId]]` is synced on every
selection, same as
[`Select()`](https://coppertank.github.io/shiny.mantine/reference/Select.md).

## Usage

``` r
ComboboxPopover(inputId, ..., data = NULL, value = NULL)

ComboboxPopoverTarget(...)

updateMantineComboboxPopover(
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

- ...:

  Other props (`searchable`, `multiple`, `nothingFoundMessage`, ...) and
  a `ComboboxPopoverTarget()` child.

- data:

  Options: a character vector, or a list of `list(value=, label=)`
  (optionally grouped: `list(group=, items=)`). See
  <https://mantine.dev/core/combobox-popover/>.

- value:

  Initial value (or `NULL`); a character vector if `multiple = TRUE`.

- session:

  Session object passed to the Shiny server function.
