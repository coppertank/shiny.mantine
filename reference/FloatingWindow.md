# Mantine FloatingWindow family (draggable, optionally resizable floating panel)

A draggable floating panel positioned anywhere in the viewport by the
user. `initialPosition` sets where it starts (plain
`list(top=, left=)`/`list(bottom=, right=)` data) — the window's *live*
position while being dragged isn't readable/settable from the server,
since that needs a client-side ref. Its parent needs
`position: relative` (or similar) for it to be positioned against it.

## Usage

``` r
FloatingWindow(..., inputId = NULL)

FloatingWindowResizeHandle(...)
```

## Arguments

- ...:

  Props and children. See <https://mantine.dev/core/floating-window/>.

- inputId:

  Optional; if set, resize events are reported to Shiny (see Details).
  Omit if you don't need to react to resizing server-side.

## Details

Add `dimensions`
(`list(initialWidth=, minWidth=, maxWidth=, initialHeight=, minHeight=, maxHeight=)`)
together with a `FloatingWindowResizeHandle()` child to make it
resizable (drag or, when the handle has keyboard focus, Arrow
keys/Home/End). If `inputId` is set, resizing (drag only — not keyboard)
is reported to Shiny: `input[[inputId]]` holds the current
`list(width=, height=)` after every resize, and
`input[[paste0(inputId, "_resize_start")]]`/
`input[[paste0(inputId, "_resize_end")]]` fire as events when a
drag-resize begins/ends (added in Mantine 9.5.1).

## Examples

``` r
if (FALSE) { # \dontrun{
Box(
  style = list(position = "relative", height = "300px"),
  FloatingWindow(
    inputId = "win_size",
    dimensions = list(initialWidth = 220, minWidth = 150, maxWidth = 400,
                       initialHeight = 140, minHeight = 100, maxHeight = 300),
    style = list(border = "1px solid #ddd", background = "white", padding = "12px"),
    Text("Drag / resize me."),
    FloatingWindowResizeHandle(style = list(position = "absolute", right = 0, bottom = 0))
  )
)
} # }
```
