# Core: Feedback

``` r

library(shiny)
library(shiny.mantine)
```

An R rewrite of the [“Feedback”
category](https://mantine.dev/core/alert/) on mantine.dev/core. For
toast-style popup notifications (as opposed to the static
[`Notification()`](https://coppertank.github.io/shiny.mantine/reference/Notification.md)
box below), see
[`vignette("satellite-packages")`](https://coppertank.github.io/shiny.mantine/articles/satellite-packages.md)’s
`@mantine/notifications` section instead — that’s a different
mantine.dev package
([`showMantineNotification()`](https://coppertank.github.io/shiny.mantine/reference/showMantineNotification.md)),
not a “core” component.

## Alert

<https://mantine.dev/core/alert/> — a colored banner with an icon,
title, and message, for inline warnings/errors/info.

``` r

Alert(
  title = "Heads up!", color = "yellow", icon = IconFingerprint(size = 18),
  "This action can't be undone."
)
```

## Loader

<https://mantine.dev/core/loader/> — a loading spinner; `type` switches
between the built-in visual styles (`"oval"`, `"bars"`, `"dots"`).

``` r

Loader(color = "blue", type = "dots")
```

## Progress

<https://mantine.dev/core/progress/> — a horizontal progress bar,
`value` between 0-100.

``` r

Progress(value = 65, color = "green", size = "lg", striped = TRUE, animated = TRUE)
```

For a multi-segment bar (several `value`s stacked in one track), use the
compound form:

``` r

ProgressRoot(
  size = "xl",
  ProgressSection(value = 40, color = "blue", ProgressLabel("Used")),
  ProgressSection(value = 20, color = "orange", ProgressLabel("Reserved"))
)
```

## RingProgress

<https://mantine.dev/core/ring-progress/> — a circular progress
indicator, `sections` is a list of `list(value=, color=)`.

``` r

RingProgress(sections = list(list(value = 40, color = "blue"), list(value = 25, color = "orange")), label = Text("65%", ta = "center"))
```

## SemiCircleProgress

<https://mantine.dev/core/semi-circle-progress/> — the half-circle
(“gauge”) variant of
[`RingProgress()`](https://coppertank.github.io/shiny.mantine/reference/RingProgress.md).

``` r

SemiCircleProgress(value = 65, filledSegmentColor = "blue", label = "65%")
```

## Skeleton

<https://mantine.dev/core/skeleton/> — an animated placeholder shown
while real content is loading.

``` r

Stack(Skeleton(height = 20, width = "70%"), Skeleton(height = 20), Skeleton(height = 100))
```

## Notification

<https://mantine.dev/core/notification/> — a static notification box for
your own layout (e.g. an activity feed item) — distinct from the toast
popups triggered with
[`showMantineNotification()`](https://coppertank.github.io/shiny.mantine/reference/showMantineNotification.md)
in
[`vignette("satellite-packages")`](https://coppertank.github.io/shiny.mantine/articles/satellite-packages.md),
which float over the page and manage their own stacking/dismissal.

``` r

Notification(title = "New message", color = "blue", onClose = NULL, "You have a new message from Ada.")
```

## EmptyState

<https://mantine.dev/core/empty-state/> (a `shiny.mantine`-generated
passthrough component; composed the same way as mantine.dev’s own
`EmptyState`) — a placeholder shown when there is no content to display,
composed of
[`EmptyStateIndicator()`](https://coppertank.github.io/shiny.mantine/reference/EmptyState.md)/[`EmptyStateTitle()`](https://coppertank.github.io/shiny.mantine/reference/EmptyState.md)/
[`EmptyStateDescription()`](https://coppertank.github.io/shiny.mantine/reference/EmptyState.md)/[`EmptyStateActions()`](https://coppertank.github.io/shiny.mantine/reference/EmptyState.md):

``` r

EmptyState(
  EmptyStateIndicator(IconSearch(size = 48)),
  EmptyStateTitle("No results found"),
  EmptyStateDescription("Try adjusting your search or filters."),
  EmptyStateActions(Button("Clear filters", inputId = "clear_filters_btn"))
)
```

## Where to go next

- [`vignette("satellite-packages")`](https://coppertank.github.io/shiny.mantine/articles/satellite-packages.md)
  — toast notifications (`@mantine/notifications`) and every other
  satellite package.
- [`vignette("core-overlays")`](https://coppertank.github.io/shiny.mantine/articles/core-overlays.md)
  —
  [`LoadingOverlay()`](https://coppertank.github.io/shiny.mantine/reference/LoadingOverlay.md)
  and other overlay components.
