# Reactive Mantine output

Analogous to
[`shiny::uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html) but
for a Mantine sub-tree: the content is reactively recomputed server-side
with `renderMantine()`, without needing to rebuild the whole page
(unlike
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md),
which mounts statically once at page load). Fills the architectural gap
of not having a
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html)/`reactOutput()`
equivalent for Mantine.

## Usage

``` r
mantineOutput(outputId)

renderMantine(expr, env = parent.frame(), quoted = FALSE)
```

## Arguments

- outputId:

  Id of the Shiny output.

- expr:

  Expression that returns a `shiny.mantine` component (or a value/tag to
  render as a child).

- env:

  Environment in which to evaluate `expr`.

- quoted:

  Is `expr` already quoted?

## Value

A `shiny.tag` to insert into the UI.

## Details

Each `mantineOutput()` mounts its own independent React root (like every
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)):
if you want Mantine's theme/color-scheme inside the output, wrap the
content in a
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)
inside the expression passed to `renderMantine()`. Every time the
expression is re-evaluated, the whole sub-tree is re-rendered: local
component state inside it (e.g. text typed into a `TextInput` not
controlled by a stable `inputId`) can be lost, exactly as with
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html).

## Examples

``` r
if (FALSE) { # \dontrun{
# ui:
mantineOutput("my_output")

# server:
output$my_output <- renderMantine({
  MantineProvider(
    Card(withBorder = TRUE, Text(paste("Updated at", Sys.time())))
  )
})
} # }
```
