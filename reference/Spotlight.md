# Mantine Spotlight (command palette, Cmd/Ctrl+K by default)

Selecting an action sends its `id` to `input[[inputId]]`.

## Usage

``` r
Spotlight(inputId, actions, ...)
```

## Arguments

- inputId:

  Id of the Shiny input that receives the selected action's `id`.

- actions:

  List of actions: each a
  `list(id = ..., label = ..., description = ...)`.

- ...:

  Other props (`shortcut`, `nothingFound`, `limit`, ...). See
  <https://mantine.dev/x/spotlight/>.

## Examples

``` r
if (FALSE) { # \dontrun{
Spotlight(
  inputId = "spotlight_action",
  actions = list(
    list(id = "home", label = "Go to Home", description = "Main page"),
    list(id = "settings", label = "Go to Settings")
  )
)
} # }
```
