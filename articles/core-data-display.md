# Core: Data display

``` r

library(shiny)
library(shiny.mantine)
```

An R rewrite of the [“Data display”
category](https://mantine.dev/core/accordion/) on mantine.dev/core.

## Accordion

<https://mantine.dev/core/accordion/> — a collapsible list of sections;
[`AccordionItem()`](https://coppertank.github.io/shiny.mantine/reference/Accordion.md)s
(each with
[`AccordionControl()`](https://coppertank.github.io/shiny.mantine/reference/Accordion.md) +
[`AccordionPanel()`](https://coppertank.github.io/shiny.mantine/reference/Accordion.md))
nest inside
[`Accordion()`](https://coppertank.github.io/shiny.mantine/reference/Accordion.md).
Set `multiple = TRUE` to allow more than one panel open at once.

``` r

Accordion(
  inputId = "faq", value = "q1",
  AccordionItem(value = "q1", AccordionControl("What is Mantine?"), AccordionPanel("A React component library.")),
  AccordionItem(value = "q2", AccordionControl("What is Shiny?"), AccordionPanel("An R web framework."))
)
```

## Avatar

<https://mantine.dev/core/avatar/> — a user profile picture (or
initials/icon fallback);
[`AvatarGroup()`](https://coppertank.github.io/shiny.mantine/reference/AvatarGroup.md)
overlaps several together.

``` r

AvatarGroup(
  Avatar(src = "https://i.pravatar.cc/100?img=1", radius = "xl"),
  Avatar(src = "https://i.pravatar.cc/100?img=2", radius = "xl"),
  Avatar("+3", radius = "xl")
)
```

## BackgroundImage

<https://mantine.dev/core/background-image/> — a container with a CSS
background image, for placing content over a photo.

``` r

BackgroundImage(src = "https://placehold.co/600x300", radius = "md", Center(h = 200, Text("Overlay text", c = "white", fw = 700)))
```

## Badge

<https://mantine.dev/core/badge/> — a small colored label/pill, commonly
used for statuses/counts.

``` r

Group(Badge("New", color = "green"), Badge("Beta", color = "yellow", variant = "outline"), Badge(3, circle = TRUE, color = "red"))
```

## Card

<https://mantine.dev/core/card/> — a bordered/shadowed content
container;
[`CardSection()`](https://coppertank.github.io/shiny.mantine/reference/CardSection.md)
marks a full-bleed section (e.g. an image touching the card’s edges)
inside it.

``` r

Card(
  withBorder = TRUE, radius = "md", w = 300,
  CardSection(Image(src = "https://placehold.co/300x140")),
  Title("Card title", order = 4, mt = "sm"),
  Text("Card description text.", size = "sm", c = "dimmed")
)
```

## ColorSwatch

<https://mantine.dev/core/color-swatch/> — a small color sample square.

``` r

Group(ColorSwatch(color = "#228be6"), ColorSwatch(color = "#40c057"), ColorSwatch(color = "#fa5252"))
```

## DataList

<https://mantine.dev/core/data-list/> — a key/value list
(definition-list style), composed of
[`DataListItem()`](https://coppertank.github.io/shiny.mantine/reference/DataList.md)/
[`DataListItemLabel()`](https://coppertank.github.io/shiny.mantine/reference/DataList.md)/[`DataListItemValue()`](https://coppertank.github.io/shiny.mantine/reference/DataList.md).

``` r

DataList(
  DataListItem(DataListItemLabel("Name"), DataListItemValue("Ada Lovelace")),
  DataListItem(DataListItemLabel("Role"), DataListItemValue("Engineer"))
)
```

## Image

<https://mantine.dev/core/image/> — a styled `<img>` with a
`fallbackSrc` option and Mantine’s radius/fit props.

``` r

Image(src = "https://placehold.co/400x200", radius = "md", fit = "cover", alt = "Placeholder")
```

## Indicator

<https://mantine.dev/core/indicator/> — a small badge/dot positioned
over an element (e.g. an unread-notifications count on a bell icon).

``` r

Indicator(label = "3", size = 16, ActionIcon(inputId = "bell_btn", variant = "light", IconBell(size = 18)))
```

## Kbd

<https://mantine.dev/core/kbd/> — renders text styled like a keyboard
key, e.g. for documenting shortcuts.

``` r

Text("Press ", Kbd("Ctrl"), " + ", Kbd("K"), " to open the command palette.")
```

## NumberFormatter

<https://mantine.dev/core/number-formatter/> — formats a numeric value
as display text (thousand separators, decimals, prefix/suffix) without
being an input.

``` r

NumberFormatter(value = 1234567.891, thousandSeparator = TRUE, decimalScale = 2, prefix = "$")
```

## RollingNumber

<https://mantine.dev/core/rolling-number/> — an animated
rolling/odometer-style number display, e.g. for a live counter.

``` r

RollingNumber(value = 1024)
```

## Spoiler

<https://mantine.dev/core/spoiler/> — truncates long content behind a
“show more” toggle.

``` r

Spoiler(maxHeight = 60, showLabel = "Show more", hideLabel = "Hide", Text(paste(rep("Long paragraph text. ", 20), collapse = "")))
```

## ThemeIcon

<https://mantine.dev/core/theme-icon/> — a colored, sized container for
an icon, matching the rest of the theme (used e.g. as a leading icon
next to a title).

``` r

Group(ThemeIcon(IconLayoutDashboard(size = 18), color = "blue", variant = "light", size = 36, radius = "md"), Title("Dashboard", order = 3))
```

## Timeline

<https://mantine.dev/core/timeline/> — a vertical sequence of events,
each a
[`TimelineItem()`](https://coppertank.github.io/shiny.mantine/reference/Timeline.md).

``` r

Timeline(active = 1, bulletSize = 24, lineWidth = 2,
  TimelineItem(title = "Order placed", "2 days ago"),
  TimelineItem(title = "Order shipped", "1 day ago"),
  TimelineItem(title = "Out for delivery", "Today")
)
```

## Table (with DataTable — a `shiny.mantine` extra)

<https://mantine.dev/core/table/> —
[`Table()`](https://coppertank.github.io/shiny.mantine/reference/Table.md)
and its sub-parts
([`TableThead()`](https://coppertank.github.io/shiny.mantine/reference/Table.md)/[`TableTbody()`](https://coppertank.github.io/shiny.mantine/reference/Table.md)/[`TableTr()`](https://coppertank.github.io/shiny.mantine/reference/Table.md)/[`TableTh()`](https://coppertank.github.io/shiny.mantine/reference/Table.md)/[`TableTd()`](https://coppertank.github.io/shiny.mantine/reference/Table.md)/…)
compose a table by hand, exactly matching plain HTML `<table>`
structure, for full control:

``` r

Table(
  TableThead(TableTr(TableTh("Name"), TableTh("Role"))),
  TableTbody(
    TableTr(TableTd("Ada"), TableTd("Engineer")),
    TableTr(TableTd("Grace"), TableTd("Researcher"))
  )
)
```

[`DataTable()`](https://coppertank.github.io/shiny.mantine/reference/DataTable.md)
is not a mantine.dev component — a `shiny.mantine` extra built on top of
[`Table()`](https://coppertank.github.io/shiny.mantine/reference/Table.md)
with search/sort/selection already wired up, reporting the currently
visible/selected row `value`s to Shiny:

``` r

DataTable(
  "team",
  data = list(list(value = 1, name = "Ada", role = "Engineer"), list(value = 2, name = "Grace", role = "Researcher")),
  columns = list(list(key = "name", label = "Name"), list(key = "role", label = "Role")),
  searchable = TRUE, sortable = TRUE, selectable = TRUE
)
```

## OverflowList (not wrapped)

<https://mantine.dev/core/overflow-list/> needs a `renderItem`/
`renderOverflow` render-prop function to customize how overflowing items
collapse into a “+N” indicator — a poor fit for R’s data-only props. Not
covered.

## Where to go next

- [`vignette("core-typography")`](https://coppertank.github.io/shiny.mantine/articles/core-typography.md)
  —
  [`Text()`](https://coppertank.github.io/shiny.mantine/reference/Text.md),
  [`Title()`](https://coppertank.github.io/shiny.mantine/reference/Title.md),
  [`Table()`](https://coppertank.github.io/shiny.mantine/reference/Table.md)’s
  typography-adjacent siblings, and more.
- [`vignette("extras")`](https://coppertank.github.io/shiny.mantine/articles/extras.md)
  —
  [`SortableList()`](https://coppertank.github.io/shiny.mantine/reference/SortableList.md)/[`SortableTable()`](https://coppertank.github.io/shiny.mantine/reference/SortableTable.md),
  two more `shiny.mantine` extras for drag-and-drop reordering.
