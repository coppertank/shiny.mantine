# Mantine Combobox family (headless dropdown primitive for custom selects)

`Combobox()` is Mantine's low-level building block for custom
select/autocomplete/multiselect UIs — the same primitive
[`Select()`](https://coppertank.github.io/shiny.mantine/reference/Select.md)/[`MultiSelect()`](https://coppertank.github.io/shiny.mantine/reference/MultiSelect.md)/[`Autocomplete()`](https://coppertank.github.io/shiny.mantine/reference/Autocomplete.md)/[`TagsInput()`](https://coppertank.github.io/shiny.mantine/reference/TagsInput.md)/[`PillsInput()`](https://coppertank.github.io/shiny.mantine/reference/PillsInput.md)
are built on top of internally. Reach for it only when those don't fit
(e.g. options need custom icons/layout beyond `renderOption`-style
composition, or a non-input target like a
[`Button()`](https://coppertank.github.io/shiny.mantine/reference/Button.md)).
See <https://mantine.dev/core/combobox/>.

## Usage

``` r
Combobox(..., inputId = NULL, opened = FALSE)

ComboboxTarget(...)

ComboboxEventsTarget(...)

ComboboxDropdownTarget(...)

ComboboxDropdown(...)

ComboboxOptions(...)

ComboboxOption(value, ...)

ComboboxSearch(inputId, value = "", ...)

updateMantineComboboxSearch(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)

ComboboxEmpty(...)

ComboboxFooter(...)

ComboboxHeader(...)

ComboboxGroup(...)

ComboboxChevron(...)

ComboboxClearButton(...)

ComboboxHiddenInput(...)
```

## Arguments

- ...:

  Other props and children — typically a `ComboboxTarget()` and a
  `ComboboxDropdown()` (`width`, `position`, `shadow`, `withArrow`,
  ...).

- inputId:

  Id of the Shiny input that receives the search text on every keystroke
  (like
  [`TextInput()`](https://coppertank.github.io/shiny.mantine/reference/TextInput.md)).

- opened:

  Whether the dropdown is open. Toggle from the server with
  [`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md)
  (needs a `mantineId`).

- value:

  Initial search text.

- session:

  Session object passed to the Shiny server function.

## Details

The real Mantine `Combobox` is driven by an imperative `useCombobox()`
store (a live JS object with methods); this package creates and owns
that store for you internally, so the pieces below stay fully
declarative:

- `ComboboxTarget()`'s single child (e.g. a
  [`Button()`](https://coppertank.github.io/shiny.mantine/reference/Button.md)
  or
  [`TextInput()`](https://coppertank.github.io/shiny.mantine/reference/TextInput.md))
  automatically toggles the dropdown on click — real Mantine requires
  wiring this by hand (`onClick={() => combobox.toggleDropdown()}`), not
  needed here.

- `ComboboxSearch()` is a text field wired to Shiny like any other input
  (`input[[inputId]]` on every keystroke) and opens the dropdown on
  focus — pair it with
  [`renderMantine()`](https://coppertank.github.io/shiny.mantine/reference/mantineOutput.md)/[`mantineOutput()`](https://coppertank.github.io/shiny.mantine/reference/mantineOutput.md)
  to re-render `ComboboxOptions()` server-side as the user types
  (server-side filtering), since an R render function cannot cross the
  bridge the way Mantine's own `filter`/`renderOption` props do.

- Selecting a `ComboboxOption()` (click or Enter) sends its `value` to
  `input[[inputId]]` of the enclosing `Combobox()` (as an event, like
  [`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html))
  and closes the dropdown. Highlighting the current selection
  (`active = TRUE` on the matching `ComboboxOption()`) is the caller's
  responsibility, same as Mantine's own controlled examples.
