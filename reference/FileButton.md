# Mantine FileButton (button that opens the native file picker)

Like
[`Dropzone()`](https://coppertank.github.io/shiny.mantine/reference/Dropzone.md),
only file *metadata* is reported to Shiny — `input[[inputId]]` receives
`list(count = <n>, files = <list with name/size/type per file>)`, never
the file content. Pair with a real
[`shiny::fileInput()`](https://rdrr.io/pkg/shiny/man/fileInput.html) if
you need the actual upload.

## Usage

``` r
FileButton(
  inputId,
  label = "Upload file",
  accept = NULL,
  multiple = FALSE,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input receiving file metadata.

- label:

  Button text.

- accept:

  MIME types accepted (e.g. `"image/png,image/jpeg"`).

- multiple:

  Whether multiple files can be selected at once.

- ...:

  Other props forwarded to the underlying button (`color`, `variant`,
  ...). See <https://mantine.dev/core/file-button/>.
