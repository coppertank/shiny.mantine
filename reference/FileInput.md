# Mantine FileInput (file selection, metadata only)

`input[[inputId]]` receives
`list(count = <n>, files = <list with name/size/type>)` — the file
*content* does not travel over this channel (like
[`Dropzone()`](https://coppertank.github.io/shiny.mantine/reference/Dropzone.md)).
Always use `$count`, not
[`length()`](https://rdrr.io/r/base/length.html).

## Usage

``` r
FileInput(inputId, label = NULL, ...)
```

## Arguments

- inputId:

  Id of the Shiny input receiving file metadata.

- label:

  Field label.

- ...:

  Other props (`multiple`, `accept`, `clearable`, ...). See
  <https://mantine.dev/core/file-input/>.
