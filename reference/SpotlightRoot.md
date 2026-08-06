# Mantine Spotlight.Root (fully custom Spotlight layout)

The lower-level piece behind
[`Spotlight()`](https://coppertank.github.io/shiny.mantine/reference/Spotlight.md),
for grouped actions (via `SpotlightActionsGroup()`) or a fully custom
search/empty/footer layout that the flat `actions` list of
[`Spotlight()`](https://coppertank.github.io/shiny.mantine/reference/Spotlight.md)
doesn't allow.

## Usage

``` r
SpotlightRoot(...)

SpotlightSearch(...)

SpotlightActionsList(...)

SpotlightActionsGroup(..., label = NULL)

SpotlightAction(inputId, value, ..., label = NULL)

SpotlightEmpty(...)

SpotlightFooter(...)
```

## Arguments

- ...:

  Children — typically `SpotlightSearch()`, `SpotlightActionsList()`
  (wrapping `SpotlightActionsGroup()`s of `SpotlightAction()`s, and/or
  `SpotlightEmpty()` — see above), and `SpotlightFooter()` — plus other
  props (`shortcut`, `scrollable`, `maxHeight`, ...). See
  <https://mantine.dev/x/spotlight/#compound-components>.

- label:

  Action label.

- inputId:

  Id of the Shiny input that receives `value` when this action is
  selected.

- value:

  Value sent to `input[[inputId]]` when selected.

## Details

Unlike
[`Spotlight()`](https://coppertank.github.io/shiny.mantine/reference/Spotlight.md),
the compound form does **not** filter actions by the search query itself
— `SpotlightSearch()` just renders the search box; matching typed text
against your `SpotlightAction()`s (and showing/hiding `SpotlightEmpty()`
when nothing matches) is up to you, typically via `onQueryChange` +
conditionally including `SpotlightEmpty()` only when your own filtering
finds nothing. Include it unconditionally and it stays visible alongside
real actions, not just when there are none.

## Examples

``` r
if (FALSE) { # \dontrun{
SpotlightRoot(
  SpotlightSearch(placeholder = "Search..."),
  SpotlightActionsList(
    SpotlightActionsGroup(
      label = "Navigation",
      SpotlightAction("spotlight_choice", "home", label = "Home"),
      SpotlightAction("spotlight_choice", "settings", label = "Settings")
    )
  )
)
} # }
```
