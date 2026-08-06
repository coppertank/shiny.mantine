# Mantine-styled notifications

Unlike
[`shiny::showNotification()`](https://rdrr.io/pkg/shiny/man/showNotification.html)
(Bootstrap-styled, clashing with the Mantine theme), these notifications
use `@mantine/notifications` — the same library as the components, the
same theme/color-scheme.

## Usage

``` r
Notifications(...)
```

## Arguments

- ...:

  Props for the container (`position`, `zIndex`, `limit`, ...). See
  <https://mantine.dev/x/notifications/>.

## Details

`Notifications()` needs to be mounted **once** in the page (typically
inside the main
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md));
after that,
[`showMantineNotification()`](https://coppertank.github.io/shiny.mantine/reference/showMantineNotification.md)
can be called from any server-side
[`observeEvent()`](https://rdrr.io/pkg/shiny/man/observeEvent.html)/reactive.

## Examples

``` r
if (FALSE) { # \dontrun{
# ui:
MantineProvider(Notifications(position = "top-right"), ...)

# server:
observeEvent(input$save_btn, {
  showMantineNotification(session, title = "Saved", message = "Changes saved successfully", color = "green")
})
} # }
```
