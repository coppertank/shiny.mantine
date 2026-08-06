# Extras & Recipes

``` r

library(shiny)
library(shiny.mantine)
```

Components covered by the `core-*` vignettes each have their own
`mantine.dev/core/...` page. This vignette covers what doesn’t:
group-input variants that are sub-sections of an existing mantine.dev
page rather than their own, two `shiny.mantine`-only drag-and-drop
reordering components, and a handful of pure-R “recipe” buttons composed
on top of
[`Button()`](https://coppertank.github.io/shiny.mantine/reference/Button.md)
(the kind shown on [ui.mantine.dev](https://ui.mantine.dev), not
mantine.dev/core).

## Group inputs

<https://mantine.dev/core/checkbox/#checkboxgroup> and
<https://mantine.dev/core/radio/#radiogroup> —
[`Checkbox()`](https://coppertank.github.io/shiny.mantine/reference/Checkbox.md)/[`Switch()`](https://coppertank.github.io/shiny.mantine/reference/Switch.md)
are single booleans; for an array-valued *group* of them, use the
dedicated
[`CheckboxGroup()`](https://coppertank.github.io/shiny.mantine/reference/CheckboxGroup.md)/[`SwitchGroup()`](https://coppertank.github.io/shiny.mantine/reference/SwitchGroup.md)
plus their own
[`CheckboxGroupItem()`](https://coppertank.github.io/shiny.mantine/reference/CheckboxGroup.md)/
[`SwitchGroupItem()`](https://coppertank.github.io/shiny.mantine/reference/SwitchGroup.md)
children (never the standalone
[`Checkbox()`](https://coppertank.github.io/shiny.mantine/reference/Checkbox.md)/[`Switch()`](https://coppertank.github.io/shiny.mantine/reference/Switch.md),
which manage their own independent checked state and would conflict with
the group’s):

``` r

Stack(
  CheckboxGroup(
    inputId = "fruits", label = "Pick fruits", value = character(0),
    CheckboxGroupItem(value = "apple", label = "Apple"),
    CheckboxGroupItem(value = "banana", label = "Banana")
  ),
  SwitchGroup(
    inputId = "features", label = "Enable features", value = character(0),
    SwitchGroupItem(value = "beta", label = "Beta features"),
    SwitchGroupItem(value = "telemetry", label = "Telemetry")
  )
)

# server:
observe(print(input$fruits))  # e.g. c("apple", "banana")
```

[`RadioGroup()`](https://coppertank.github.io/shiny.mantine/reference/RadioGroup.md)/[`ChipGroup()`](https://coppertank.github.io/shiny.mantine/reference/ChipGroup.md)
(covered in
[`vignette("core-inputs")`](https://coppertank.github.io/shiny.mantine/articles/core-inputs.md))
already follow this same pattern, but nest the plain
[`Radio()`](https://coppertank.github.io/shiny.mantine/reference/RadioGroup.md)/[`Chip()`](https://coppertank.github.io/shiny.mantine/reference/ChipGroup.md)
directly since those don’t have a separate `checked` state of their own
to conflict with.

<https://mantine.dev/core/checkbox/#checkboxcard> —
[`CheckboxCard()`](https://coppertank.github.io/shiny.mantine/reference/CheckboxCard.md)/
[`RadioCard()`](https://coppertank.github.io/shiny.mantine/reference/CheckboxCard.md)
are card-styled selectable items: visually a bordered, clickable card
instead of a small checkbox/radio circle, nested the same way inside
[`CheckboxGroup()`](https://coppertank.github.io/shiny.mantine/reference/CheckboxGroup.md)/[`RadioGroup()`](https://coppertank.github.io/shiny.mantine/reference/RadioGroup.md):

``` r

RadioGroup(
  inputId = "plan", label = "Choose a plan", value = "free",
  RadioCard(value = "free", Text("Free")),
  RadioCard(value = "pro", Text("Pro"))
)
```

[`RadioIndicator()`](https://coppertank.github.io/shiny.mantine/reference/RadioIndicator.md)/[`CheckboxIndicator()`](https://coppertank.github.io/shiny.mantine/reference/RadioIndicator.md)
are the purely decorative “checked” look
[`Radio()`](https://coppertank.github.io/shiny.mantine/reference/RadioGroup.md)/[`Checkbox()`](https://coppertank.github.io/shiny.mantine/reference/Checkbox.md)
render internally, usable without a real input behind them — e.g. a
read-only status list:

``` r

Group(RadioIndicator(checked = TRUE), Text("Step 1 complete"))
```

## Drag-and-drop reordering (`shiny.mantine` extras)

Not mantine.dev components — built on `@hello-pangea/dnd` to fill a gap
Mantine core itself doesn’t cover. After each reorder,
`input[[inputId]]` receives the new order as a vector of `value`.

[`SortableList()`](https://coppertank.github.io/shiny.mantine/reference/SortableList.md)
reorders a plain list of `list(value=, label=)` items, optionally
restricting the drag start to a handle icon:

``` r

SortableList(
  "elements", withHandle = TRUE,
  items = list(
    list(value = "H", label = "Hydrogen"),
    list(value = "He", label = "Helium")
  )
)

# server:
observe(print(input$elements))  # e.g. c("He", "H") after dragging Helium to the top
```

[`SortableTable()`](https://coppertank.github.io/shiny.mantine/reference/SortableTable.md)
is the same idea for full table rows (`cells` = the values for each
column):

``` r

SortableTable(
  "periodic_rows",
  columns = c("Symbol", "Name"),
  items = list(
    list(value = "H", cells = list("H", "Hydrogen")),
    list(value = "He", cells = list("He", "Helium"))
  )
)
```

## Button recipes

Pure R compositions on top of
[`Button()`](https://coppertank.github.io/shiny.mantine/reference/Button.md)/[`ActionIcon()`](https://coppertank.github.io/shiny.mantine/reference/ActionIcon.md)
for patterns shown on
[ui.mantine.dev/category/buttons](https://ui.mantine.dev/category/buttons/)
— not separate mantine.dev/core pages, so not covered in
[`vignette("core-buttons")`](https://coppertank.github.io/shiny.mantine/articles/core-buttons.md).
See `inst/examples/buttons-app.R` for a runnable demo of all of them
together.

[`ColorSchemeToggle()`](https://coppertank.github.io/shiny.mantine/reference/ColorSchemeToggle.md)
flips the whole
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)’s
light/dark theme:

``` r

ColorSchemeToggle(inputId = "scheme_toggle")
```

[`ButtonWithMenu()`](https://coppertank.github.io/shiny.mantine/reference/ButtonWithMenu.md)
opens a dropdown menu on click, items passed as
[`menuItem()`](https://coppertank.github.io/shiny.mantine/reference/menuItem.md):

``` r

ButtonWithMenu(
  "Create new",
  menuItem("create_action", "project", "Project"),
  menuItem("create_action", "folder", "Folder")
)
```

[`SplitButton()`](https://coppertank.github.io/shiny.mantine/reference/SplitButton.md)
pairs a primary action with a small arrow opening a menu of
alternatives:

``` r

SplitButton(
  "Send", inputId = "send_btn",
  menuItem("send_action", "now", "Send now"),
  menuItem("send_action", "schedule", "Schedule send")
)
```

[`LoadingProgressButton()`](https://coppertank.github.io/shiny.mantine/reference/LoadingProgressButton.md)
shows a simulated progress bar over itself on click; `input[[inputId]]`
receives `TRUE` when it reaches 100%:

``` r

LoadingProgressButton("Upload", inputId = "upload_done", loadingLabel = "Uploading...")
```

[`SocialButton()`](https://coppertank.github.io/shiny.mantine/reference/SocialButton.md)
is a preconfigured icon + color + label for a common provider
(`"google"`, `"twitter"`, `"facebook"`, `"github"`, `"discord"`) — copy
and adapt its source in `R/Buttons.R` if you need another provider:

``` r

Stack(
  SocialButton("google", inputId = "google_login"),
  SocialButton("github", inputId = "github_login")
)
```

## Where to go next

- [`vignette("core-layout")`](https://coppertank.github.io/shiny.mantine/articles/core-layout.md)
  — where the tour of mantine.dev/core starts.
- [`vignette("core-inputs")`](https://coppertank.github.io/shiny.mantine/articles/core-inputs.md)
  —
  [`RadioGroup()`](https://coppertank.github.io/shiny.mantine/reference/RadioGroup.md)/[`ChipGroup()`](https://coppertank.github.io/shiny.mantine/reference/ChipGroup.md),
  the group inputs that don’t need their own `*Item()` wrapper.
- [`vignette("architecture")`](https://coppertank.github.io/shiny.mantine/articles/architecture.md)
  — how every component here is serialized and kept in sync with Shiny
  under the hood.
