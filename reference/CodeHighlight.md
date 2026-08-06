# Mantine CodeHighlight (code block)

No syntax coloring (always uses a "plain text adapter" to avoid bloating
the bundle with `highlight.js`/`shiki`): the block still shows with a
monospace font, line numbers, a "copy" button, and a language label —
just without the colors.

## Usage

``` r
CodeHighlight(code, language = NULL, ...)

InlineCodeHighlight(code, language = NULL, ...)
```

## Arguments

- code:

  The code to display (a string).

- language:

  Language (label only, e.g. `"r"`, `"js"`).

- ...:

  Other props (`withCopyButton`, `copyLabel`, ...). See
  <https://mantine.dev/x/code-highlight/>.
