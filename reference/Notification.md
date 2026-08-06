# Mantine Notification (static notification box)

A notification-styled box rendered directly in the page layout —
distinct from the toast popups shown by
[`showMantineNotification()`](https://coppertank.github.io/shiny.mantine/reference/showMantineNotification.md)
(the `@mantine/notifications` system), which mount/unmount on their own
outside the normal component tree. Use this one when you want a
dismissable notification-styled box as part of your regular layout (e.g.
inside
[`renderMantine()`](https://coppertank.github.io/shiny.mantine/reference/mantineOutput.md)/[`mantineOutput()`](https://coppertank.github.io/shiny.mantine/reference/mantineOutput.md)
to show/hide it reactively) instead of a transient popup. `onClose` is
not wired to Shiny by default; if you need the built-in close button to
do something, pair this with
[`mantineOutput()`](https://coppertank.github.io/shiny.mantine/reference/mantineOutput.md)/[`renderMantine()`](https://coppertank.github.io/shiny.mantine/reference/mantineOutput.md)
and drive visibility from the server.

## Usage

``` r
Notification(...)
```

## Arguments

- ...:

  Props and children (`title`, `color`, `icon`, `withCloseButton`, ...).
  See <https://mantine.dev/core/notification/>.
