import React, { useEffect } from 'react';
import { RichTextEditor } from '@mantine/tiptap';
import '@mantine/tiptap/styles.css';
import { useEditor } from '@tiptap/react';
import StarterKit from '@tiptap/starter-kit';
import Highlight from '@tiptap/extension-highlight';
import Superscript from '@tiptap/extension-superscript';
import Subscript from '@tiptap/extension-subscript';
import { TaskList, TaskItem } from '@tiptap/extension-list';
import TextAlign from '@tiptap/extension-text-align';
import Placeholder from '@tiptap/extension-placeholder';
import { setShinyValue, inputUpdateHandlers } from '../shared';

// @mantine/tiptap: rich text editor. Reduced scope compared to full tiptap
// (no tables/images/text color/collaboration): only basic formatting
// (bold, italic, underline, strikethrough, highlight, inline code,
// headings, blockquote, lists incl. task lists, links, alignment,
// sub/superscript), which covers the vast majority of use cases in a
// Shiny form. The content's HTML is reported to Shiny as a regular input
// (like a textarea), not as an "event": every edit updates
// `input$inputId`.

// Every button in CONTROL_MAP has a matching extension registered below
// (unlike the original implementation, which rendered a Highlight button
// with no Highlight mark ever registered - a no-op click). ColorPicker/
// Color/UnsetColor are intentionally left out: they need the Color/
// TextStyle extensions plus a swatches configuration, out of scope for
// this reduced editor - see the architecture vignette.
const CONTROL_MAP = {
  bold: RichTextEditor.Bold,
  italic: RichTextEditor.Italic,
  underline: RichTextEditor.Underline,
  strikethrough: RichTextEditor.Strikethrough,
  clearFormatting: RichTextEditor.ClearFormatting,
  highlight: RichTextEditor.Highlight,
  code: RichTextEditor.Code,
  codeBlock: RichTextEditor.CodeBlock,
  h1: RichTextEditor.H1,
  h2: RichTextEditor.H2,
  h3: RichTextEditor.H3,
  h4: RichTextEditor.H4,
  h5: RichTextEditor.H5,
  h6: RichTextEditor.H6,
  blockquote: RichTextEditor.Blockquote,
  hr: RichTextEditor.Hr,
  bulletList: RichTextEditor.BulletList,
  orderedList: RichTextEditor.OrderedList,
  taskList: RichTextEditor.TaskList,
  taskListLift: RichTextEditor.TaskListLift,
  taskListSink: RichTextEditor.TaskListSink,
  link: RichTextEditor.Link,
  unlink: RichTextEditor.Unlink,
  alignLeft: RichTextEditor.AlignLeft,
  alignCenter: RichTextEditor.AlignCenter,
  alignRight: RichTextEditor.AlignRight,
  alignJustify: RichTextEditor.AlignJustify,
  superscript: RichTextEditor.Superscript,
  subscript: RichTextEditor.Subscript,
  undo: RichTextEditor.Undo,
  redo: RichTextEditor.Redo,
};

const DEFAULT_CONTROLS = [
  ['bold', 'italic', 'underline', 'strikethrough', 'clearFormatting', 'highlight', 'code'],
  ['h1', 'h2', 'h3', 'h4'],
  ['blockquote', 'hr', 'bulletList', 'orderedList', 'taskList'],
  ['link', 'unlink'],
  ['alignLeft', 'alignCenter', 'alignRight', 'alignJustify'],
  ['subscript', 'superscript'],
  ['undo', 'redo'],
];

function ShinyRichTextEditor({
  inputId, content: initialContent, placeholder, controls, ...props
}) {
  const editor = useEditor({
    // StarterKit bundles Link/Underline itself (as of @tiptap/starter-kit
    // 3.29) - adding them again separately would register two competing
    // instances of the same mark/node ("Duplicate extension names" tiptap
    // warning).
    extensions: [
      StarterKit,
      Highlight,
      Superscript,
      Subscript,
      TaskList,
      TaskItem.configure({ nested: true }),
      TextAlign.configure({ types: ['heading', 'paragraph'] }),
      ...(placeholder ? [Placeholder.configure({ placeholder })] : []),
    ],
    content: initialContent || '',
    onUpdate: ({ editor: ed }) => {
      setShinyValue(inputId, ed.getHTML());
    },
  });

  useEffect(() => {
    if (!editor) return undefined;
    setShinyValue(inputId, editor.getHTML());
    inputUpdateHandlers[inputId] = (html) => {
      if (html !== editor.getHTML()) editor.commands.setContent(html || '');
    };
    return () => { delete inputUpdateHandlers[inputId]; };
  }, [editor, inputId]);

  // Guards against a non-array group reaching here (e.g. a single-control
  // group serialized as a bare string) - see the comment on the `controls`
  // argument in R/RichTextEditor.R for why the R side already normalizes
  // this; kept here too as a cheap defense against a corrupt/handwritten
  // payload crashing the whole editor.
  const groups = (controls || DEFAULT_CONTROLS).map((group) => (Array.isArray(group) ? group : [group]));

  return React.createElement(
    RichTextEditor,
    { editor, ...props },
    React.createElement(
      RichTextEditor.Toolbar,
      { sticky: true },
      groups.map((group, groupIndex) => React.createElement(
        RichTextEditor.ControlsGroup,
        // eslint-disable-next-line react/no-array-index-key
        { key: groupIndex },
        group.map((name) => {
          const Control = CONTROL_MAP[name];
          return Control ? React.createElement(Control, { key: name }) : null;
        }),
      )),
    ),
    React.createElement(RichTextEditor.Content),
  );
}

export const components = { RichTextEditor: ShinyRichTextEditor };
