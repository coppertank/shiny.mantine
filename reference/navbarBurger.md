# Burger wired to a boolean toggle Shiny input

Useful to open/close a responsive navbar on mobile.

## Usage

``` r
navbarBurger(inputId, opened = FALSE, ...)
```

## Arguments

- inputId:

  Id of the boolean toggle Shiny input.

- opened:

  Current state (for the icon's animation); the value sent on click is
  `!opened`.

- ...:

  Other props forwarded to `Burger` (`size`, `color`, ...).
