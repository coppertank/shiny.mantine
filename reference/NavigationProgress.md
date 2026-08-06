# Mantine NavigationProgress (progress bar at the top of the page)

Should be inserted once in the UI (typically inside
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md),
the same way as
[`Notifications()`](https://coppertank.github.io/shiny.mantine/reference/Notifications.md));
it is then driven from the server with the imperative functions
`startMantineProgress()`, `setMantineProgress()`,
`incrementMantineProgress()`, `decrementMantineProgress()`,
`completeMantineProgress()`, and `resetMantineProgress()`.

## Usage

``` r
NavigationProgress(...)

startMantineProgress(session = shiny::getDefaultReactiveDomain())

setMantineProgress(value, session = shiny::getDefaultReactiveDomain())

incrementMantineProgress(
  value = NULL,
  session = shiny::getDefaultReactiveDomain()
)

decrementMantineProgress(
  value = NULL,
  session = shiny::getDefaultReactiveDomain()
)

completeMantineProgress(session = shiny::getDefaultReactiveDomain())

resetMantineProgress(session = shiny::getDefaultReactiveDomain())
```

## Arguments

- ...:

  Optional props (`color`, `size`, `zIndex`, ...). See
  <https://mantine.dev/x/nprogress/>.

- session:

  Shiny session.

- value:

  Percentage value (0-100).

## Examples

``` r
if (FALSE) { # \dontrun{
# ui:
MantineProvider(NavigationProgress(), ...)

# server:
observeEvent(input$go, {
  startMantineProgress(session)
  ...
  completeMantineProgress(session)
})
} # }
```
