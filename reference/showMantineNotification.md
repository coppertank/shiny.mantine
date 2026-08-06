# Show/hide a Mantine notification

Show/hide a Mantine notification

## Usage

``` r
showMantineNotification(session = shiny::getDefaultReactiveDomain(), ...)

hideMantineNotification(session = shiny::getDefaultReactiveDomain(), id)
```

## Arguments

- session:

  Session object passed to the Shiny server function.

- ...:

  Notification props (`title`, `message`, `color`, `icon`, `autoClose`,
  `withCloseButton`, `id`, ...). See
  <https://mantine.dev/x/notifications/#notifications-system>.

- id:

  Id of the notification to hide (the one passed to
  `showMantineNotification(id = ...)`).

## Value

None. Called for its side effect.
