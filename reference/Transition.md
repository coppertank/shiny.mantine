# Mantine Transition (mount/unmount animation)

Animates its children in and out based on `mounted`. Mantine's own
`Transition` takes a render-prop `children` (a function receiving the
current transition styles) — incompatible with R's plain, data-only
`...` children, so this wraps it internally and applies the styles to a
plain wrapper `<div>` around your (static) children instead.

## Usage

``` r
Transition(mounted = TRUE, ...)
```

## Arguments

- mounted:

  Whether the children should be visible/mounted.

- ...:

  Props (`transition`, `duration`, `timingFunction`, ...) and the
  children to animate. See <https://mantine.dev/core/transition/>.

## Examples

``` r
if (FALSE) { # \dontrun{
Transition(
  mounted = input$show, transition = "fade", duration = 200,
  Card(withBorder = TRUE, Text("Animated in/out"))
)
} # }
```
