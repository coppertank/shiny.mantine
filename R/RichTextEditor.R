#' @include mantine-element.R
NULL

#' Mantine RichTextEditor (rich text editor, based on Tiptap)
#'
#' Reduced scope compared to full Tiptap: only basic formatting (bold,
#' italic, underline, strikethrough, highlight, inline code, headings,
#' blockquote, lists incl. task lists, links, alignment, sub/superscript)
#' — no tables, images, text color, or collaborative editing.
#' `input[[inputId]]` is updated on every edit with the content as HTML.
#'
#' @param inputId Id of the Shiny input; `input[[inputId]]` will hold the
#'   content's HTML.
#' @param content Initial HTML content of the editor.
#' @param placeholder Placeholder text shown when the editor is empty.
#' @param controls Toolbar layout: a list of character vectors, one per
#'   `ControlsGroup` (a visually separated cluster of buttons). Available
#'   control names: `"bold"`, `"italic"`, `"underline"`, `"strikethrough"`,
#'   `"clearFormatting"`, `"highlight"`, `"code"`, `"codeBlock"`, `"h1"`-
#'   `"h6"`, `"blockquote"`, `"hr"`, `"bulletList"`, `"orderedList"`,
#'   `"taskList"`, `"taskListLift"`, `"taskListSink"`, `"link"`,
#'   `"unlink"`, `"alignLeft"`, `"alignCenter"`, `"alignRight"`,
#'   `"alignJustify"`, `"superscript"`, `"subscript"`, `"undo"`, `"redo"`.
#'   Defaults to a sensible full set; pass a shorter list to trim the
#'   toolbar down, e.g. `list(c("bold", "italic"), c("bulletList",
#'   "orderedList"))`.
#' @param ... Other props passed to `@mantine/tiptap`'s `RichTextEditor`
#'   component (e.g. `minHeight`, `stickyOffset`). See
#'   <https://mantine.dev/x/tiptap/>.
#' @return A `mantine_element` to nest inside [MantineProvider()].
#' @export
#' @examples
#' \dontrun{
#' RichTextEditor("bio", content = "<p>Write something...</p>")
#'
#' # Trimmed-down toolbar
#' RichTextEditor(
#'   "bio",
#'   content = "<p>Write something...</p>",
#'   controls = list(c("bold", "italic"), c("bulletList", "orderedList"))
#' )
#' }
RichTextEditor <- function(inputId, content = "", placeholder = NULL, controls = NULL, ...) {
  mantineElement(
    "RichTextEditor",
    inputId = inputId,
    content = content,
    placeholder = placeholder,
    # A single-control group (e.g. list(c("bold"))) is an atomic vector of
    # length 1 - jsonlite's auto_unbox (see renderMantineRoot()) would
    # serialize it as a bare JSON string instead of a 1-element array,
    # crashing the JS side's group.map(). as.list() guarantees each group
    # stays a genuine (unnamed) list, and therefore a JSON array, no matter
    # its length.
    controls = if (!is.null(controls)) lapply(controls, as.list),
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
