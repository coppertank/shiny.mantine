# Mantine Dropzone (drag & drop upload)

When files are dropped (or selected via click), `input[[inputId]]`
receives
`list(count = <number of files>, files = <one element per file, with name/size/type>)`
— the file *content* is not uploaded over this channel. If you need to
actually upload the files, pair this with a regular
[`shiny::fileInput()`](https://rdrr.io/pkg/shiny/man/fileInput.html)
(you can hide it via CSS and trigger it from a click on the Dropzone).
Always use `input[[inputId]]$count` for the file count (not
`length(input[[inputId]])`): a JSON array with a single object gets
"flattened" by R differently than one with several objects, making
[`length()`](https://rdrr.io/r/base/length.html) on `$files` alone
unreliable.

Like `Dropzone()`, but instead of a fixed drop area, listens for drops
anywhere on the page while `active` is `TRUE` — typically toggled by a
button (`updateMantineProps(session, mantineId, active = TRUE/FALSE)`).
Reports the same `{count, files}` metadata to `input[[inputId]]` as
`Dropzone()`.

## Usage

``` r
Dropzone(inputId, ..., accept = NULL, maxSize = NULL)

DropzoneFullScreen(inputId, ..., active = FALSE, accept = NULL, maxSize = NULL)

DropzoneAccept(...)

DropzoneReject(...)

DropzoneIdle(...)
```

## Arguments

- inputId:

  Id of the Shiny input receiving file metadata.

- ...:

  Children (typically `DropzoneAccept()`/`DropzoneReject()`/
  `DropzoneIdle()` with icons + text) and other props forwarded to
  `Dropzone` (`multiple`, `loading`, ...). See
  <https://mantine.dev/x/dropzone/>.

- accept:

  Vector of accepted MIME types (e.g. `c("application/pdf")`); `NULL` to
  accept everything.

- maxSize:

  Maximum size per file in bytes (`NULL` for no limit).

- active:

  Whether the full-screen dropzone is currently listening for drops
  anywhere in the browser window. Toggle from the server with
  [`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md)
  (needs a `mantineId`).

## Examples

``` r
if (FALSE) { # \dontrun{
DropzoneFullScreen(
  inputId = "files", mantineId = "full_dz", active = FALSE,
  Text("Drop files anywhere on the page")
)
# server:
observeEvent(input$activate_btn, {
  updateMantineProps(session, "full_dz", active = TRUE)
})
} # }
```
