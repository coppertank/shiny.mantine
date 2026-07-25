#' @include mantine-element.R
NULL

#' Mantine RichTextEditor (rich text editor, based on Tiptap)
#'
#' Reduced scope compared to full Tiptap: only basic formatting
#' (bold/italic/underline, headings, lists, blockquotes, links, alignment)
#' — no tables, images, or collaborative editing. `input[[inputId]]` is
#' updated on every edit with the content as HTML.
#'
#' @param inputId Id of the Shiny input; `input[[inputId]]` will hold the
#'   content's HTML.
#' @param content Initial HTML content of the editor.
#' @param placeholder Placeholder text shown when the editor is empty.
#' @param ... Other props passed to `@mantine/tiptap`'s `RichTextEditor`
#'   component (e.g. `minHeight`). See <https://mantine.dev/x/tiptap/>.
#' @return A `mantine_element` to nest inside [MantineProvider()].
#' @export
#' @examples
#' \dontrun{
#' RichTextEditor("bio", content = "<p>Write something...</p>")
#' }
RichTextEditor <- function(inputId, content = "", placeholder = NULL, ...) {
  mantineElement(
    "RichTextEditor",
    inputId = inputId,
    content = content,
    placeholder = placeholder,
    ...
  )
}

#' @rdname RichTextEditor
#' @param session Session object passed to the Shiny server function.
#' @export
updateMantineRichTextEditor <- function(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  content
) {
  session$sendCustomMessage(
    "shinyMantineUpdateInput",
    list(
      inputId = session$ns(inputId),
      value = content
    )
  )
}
