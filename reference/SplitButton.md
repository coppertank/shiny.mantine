# Split button

A primary action (button, clicks increment `input[[inputId]]` like
[`Button()`](https://coppertank.github.io/shiny.mantine/reference/Button.md))
paired with a small arrow that opens a menu of alternative actions —
items should be passed as
[`menuItem()`](https://coppertank.github.io/shiny.mantine/reference/menuItem.md)
among the `...`.

## Usage

``` r
SplitButton(label, inputId = NULL, ..., color = "blue")
```

## Arguments

- label:

  Label of the primary action.

- inputId:

  Id of the Shiny input incremented by clicking the primary action.

- ...:

  Items of the alternative menu (typically
  [`menuItem()`](https://coppertank.github.io/shiny.mantine/reference/menuItem.md))
  and other props forwarded to the primary `Button`.

- color:

  Color shared by the button and the arrow.

## Examples

``` r
if (FALSE) { # \dontrun{
SplitButton(
  "Send",
  inputId = "send_btn",
  menuItem("send_action", "now", "Send now"),
  menuItem("send_action", "schedule", "Schedule send")
)
} # }
```
