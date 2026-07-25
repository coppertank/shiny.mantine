#' @include mantine-element.R
NULL

#' Mantine Dropzone (drag & drop upload)
#'
#' When files are dropped (or selected via click), `input[[inputId]]`
#' receives `list(count = <number of files>, files = <one element per
#' file, with name/size/type>)` — the file *content* is not uploaded over
#' this channel. If you need to actually upload the files, pair this with
#' a regular `shiny::fileInput()` (you can hide it via CSS and trigger it
#' from a click on the Dropzone). Always use `input[[inputId]]$count` for
#' the file count (not `length(input[[inputId]])`): a JSON array with a
#' single object gets "flattened" by R differently than one with several
#' objects, making `length()` on `$files` alone unreliable.
#'
#' @param inputId Id of the Shiny input receiving file metadata.
#' @param ... Children (typically [DropzoneAccept()]/[DropzoneReject()]/
#'   [DropzoneIdle()] with icons + text) and other props forwarded to
#'   `Dropzone` (`multiple`, `loading`, ...). See
#'   <https://mantine.dev/x/dropzone/>.
#' @param accept Vector of accepted MIME types (e.g.
#'   `c("application/pdf")`); `NULL` to accept everything.
#' @param maxSize Maximum size per file in bytes (`NULL` for no limit).
#' @export
Dropzone <- function(inputId, ..., accept = NULL, maxSize = NULL) {
  mantineElement(
    "Dropzone",
    inputId = inputId,
    accept = accept,
    maxSize = maxSize,
    ...
  )
}

#' @rdname Dropzone
#' @export
DropzoneAccept <- displayComponent("Dropzone.Accept")

#' @rdname Dropzone
#' @export
DropzoneReject <- displayComponent("Dropzone.Reject")

#' @rdname Dropzone
#' @export
DropzoneIdle <- displayComponent("Dropzone.Idle")
