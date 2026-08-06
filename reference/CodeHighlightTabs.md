# Mantine CodeHighlightTabs (tabbed multi-file code block)

Like
[`CodeHighlight()`](https://coppertank.github.io/shiny.mantine/reference/CodeHighlight.md)
(same plain-text adapter, no syntax coloring), but displays several code
snippets as a tabbed file browser.

## Usage

``` r
CodeHighlightTabs(code, ...)
```

## Arguments

- code:

  A list of `list(code = ..., language = ..., fileName = ...)`, one per
  tab.

- ...:

  Other props (`withCopyButton`, `defaultActiveTab`, ...). See
  <https://mantine.dev/x/code-highlight/#codehighlighttabs>.

## Examples

``` r
if (FALSE) { # \dontrun{
CodeHighlightTabs(code = list(
  list(fileName = "app.R", language = "r", code = "shiny::runApp()"),
  list(fileName = "index.js", language = "js", code = "console.log('hi')")
))
} # }
```
