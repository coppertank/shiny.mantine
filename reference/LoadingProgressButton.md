# Button with loading progress

On click, shows a simulated progress bar over the button (disabled
during loading). When the bar reaches 100%, `input[[inputId]]` receives
`TRUE`.

## Usage

``` r
LoadingProgressButton(label, inputId = NULL, loadingLabel = "Loading...", ...)
```

## Arguments

- label:

  Normal button label.

- inputId:

  If provided, receives `TRUE` on completion.

- loadingLabel:

  Label shown while loading.

- ...:

  Other props forwarded to the underlying `Button`.
