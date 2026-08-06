# Mantine RichTextEditor (rich text editor, based on Tiptap)

Reduced scope compared to full Tiptap: only basic formatting (bold,
italic, underline, strikethrough, highlight, inline code, headings,
blockquote, lists incl. task lists, links, alignment, sub/superscript) —
no tables, images, text color, or collaborative editing.
`input[[inputId]]` is updated on every edit with the content as HTML.

## Usage

``` r
RichTextEditor(inputId, content = "", placeholder = NULL, controls = NULL, ...)

updateMantineRichTextEditor(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  content
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` will hold the content's
  HTML.

- content:

  Initial HTML content of the editor.

- placeholder:

  Placeholder text shown when the editor is empty.

- controls:

  Toolbar layout: a list of character vectors, one per `ControlsGroup`
  (a visually separated cluster of buttons). Available control names:
  `"bold"`, `"italic"`, `"underline"`, `"strikethrough"`,
  `"clearFormatting"`, `"highlight"`, `"code"`, `"codeBlock"`, `"h1"`-
  `"h6"`, `"blockquote"`, `"hr"`, `"bulletList"`, `"orderedList"`,
  `"taskList"`, `"taskListLift"`, `"taskListSink"`, `"link"`,
  `"unlink"`, `"alignLeft"`, `"alignCenter"`, `"alignRight"`,
  `"alignJustify"`, `"superscript"`, `"subscript"`, `"undo"`, `"redo"`.
  Defaults to a sensible full set; pass a shorter list to trim the
  toolbar down, e.g.
  `list(c("bold", "italic"), c("bulletList", "orderedList"))`.

- ...:

  Other props passed to `@mantine/tiptap`'s `RichTextEditor` component
  (e.g. `minHeight`, `stickyOffset`). See
  <https://mantine.dev/x/tiptap/>.

- session:

  Session object passed to the Shiny server function.

## Value

A `mantine_element` to nest inside
[`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md).

## Examples

``` r
if (FALSE) { # \dontrun{
RichTextEditor("bio", content = "<p>Write something...</p>")

# Trimmed-down toolbar
RichTextEditor(
  "bio",
  content = "<p>Write something...</p>",
  controls = list(c("bold", "italic"), c("bulletList", "orderedList"))
)
} # }
```
