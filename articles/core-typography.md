# Core: Typography

``` r

library(shiny)
library(shiny.mantine)
```

An R rewrite of the [“Typography”
category](https://mantine.dev/core/text/) on mantine.dev/core.
[`Table()`](https://coppertank.github.io/shiny.mantine/reference/Table.md)
is covered in
[`vignette("core-data-display")`](https://coppertank.github.io/shiny.mantine/articles/core-data-display.md)
instead, matching mantine.dev’s own categorization of it as data
display.

## Text

<https://mantine.dev/core/text/> — the base text component; every
size/color/weight prop (`size`, `c` for color, `fw`, `ta`, `truncate`,
…) works exactly as documented on mantine.dev.

``` r

Text("Regular paragraph text.")
Text("Dimmed, smaller helper text.", size = "sm", c = "dimmed")
Text("Bold, colored text.", fw = 700, c = "blue")
```

[`Text()`](https://coppertank.github.io/shiny.mantine/reference/Text.md)
also supports a gradient variant:

``` r

Text("Gradient heading", variant = "gradient", gradient = list(from = "blue", to = "cyan"), fw = 900, size = "xl")
```

## Title

<https://mantine.dev/core/title/> — semantic headings (`order` 1-6,
mapping to `<h1>`-`<h6>`).

``` r

Stack(Title("Heading 1", order = 1), Title("Heading 2", order = 2), Title("Heading 3", order = 3))
```

## Blockquote

<https://mantine.dev/core/blockquote/> — a styled quotation block, with
an optional `cite` and `icon`.

``` r

Blockquote(cite = "– Ada Lovelace", icon = IconFingerprint(size = 20), "The Analytical Engine has no pretensions whatever to originate anything.")
```

## Code

<https://mantine.dev/core/code/> — inline or block code-styled text (for
real syntax-highlighted code blocks, see
[`CodeHighlight()`](https://coppertank.github.io/shiny.mantine/reference/CodeHighlight.md)
in
[`vignette("satellite-packages")`](https://coppertank.github.io/shiny.mantine/articles/satellite-packages.md)
instead).

``` r

Text("Run ", Code("install.packages(\"shiny\")"), " to get started.")
Code(block = TRUE, "shiny::runApp(\"app.R\")")
```

## Highlight

<https://mantine.dev/core/highlight/> — renders text with one or more
substrings visually highlighted.

``` r

Highlight(highlight = c("Mantine", "Shiny"), "shiny.mantine brings Mantine UI to Shiny apps.")
```

## List

<https://mantine.dev/core/list/> — a bulleted or numbered list;
[`ListItem()`](https://coppertank.github.io/shiny.mantine/reference/List.md)s
nest inside.

``` r

List(type = "ordered", ListItem("First step"), ListItem("Second step"), ListItem("Third step"))
```

## Mark

<https://mantine.dev/core/mark/> — highlighted text using the native
`<mark>` element (a simpler, single-purpose alternative to
[`Highlight()`](https://coppertank.github.io/shiny.mantine/reference/Highlight.md)
when you already know exactly which text node to mark).

``` r

Text("This is ", Mark("marked"), " text.")
```

## Typography

<https://mantine.dev/core/typography/> — applies Mantine’s prose styling
(headings, links, lists, code blocks, …) to arbitrary raw HTML content,
e.g. Markdown rendered server-side.

``` r

Typography(HTML(markdown::markdownToHTML(text = "# Title\n\nSome **bold** text and a [link](https://mantine.dev).", fragment.only = TRUE)))
```

## Where to go next

- [`vignette("core-data-display")`](https://coppertank.github.io/shiny.mantine/articles/core-data-display.md)
  —
  [`Table()`](https://coppertank.github.io/shiny.mantine/reference/Table.md)
  and other components that display structured data.
- [`vignette("core-misc")`](https://coppertank.github.io/shiny.mantine/articles/core-misc.md)
  —
  [`Divider()`](https://coppertank.github.io/shiny.mantine/reference/Divider.md),
  [`Paper()`](https://coppertank.github.io/shiny.mantine/reference/Paper.md),
  and other miscellaneous layout/display primitives.
