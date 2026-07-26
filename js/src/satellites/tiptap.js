import React, { useEffect } from 'react';
import { RichTextEditor } from '@mantine/tiptap';
import '@mantine/tiptap/styles.css';
import { useEditor } from '@tiptap/react';
import StarterKit from '@tiptap/starter-kit';
import Underline from '@tiptap/extension-underline';
import Link from '@tiptap/extension-link';
import TextAlign from '@tiptap/extension-text-align';
import Placeholder from '@tiptap/extension-placeholder';
import { setShinyValue, inputUpdateHandlers } from '../shared';

// @mantine/tiptap: rich text editor. Reduced scope compared to full tiptap
// (no tables/images/collaboration): only basic formatting (bold, italic,
// lists, headings, links, alignment), which covers the vast majority of
// use cases in a Shiny form. The content's HTML is reported to Shiny as a
// regular input (like a textarea), not as an "event": every edit updates
// `input$inputId`.
function ShinyRichTextEditor({
  inputId, content: initialContent, placeholder, ...props
}) {
  const editor = useEditor({
    extensions: [
      StarterKit,
      Underline,
      Link,
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

  return React.createElement(
    RichTextEditor,
    { editor, ...props },
    React.createElement(
      RichTextEditor.Toolbar,
      { sticky: true },
      React.createElement(
        RichTextEditor.ControlsGroup,
        null,
        React.createElement(RichTextEditor.Bold),
        React.createElement(RichTextEditor.Italic),
        React.createElement(RichTextEditor.Underline),
        React.createElement(RichTextEditor.Strikethrough),
        React.createElement(RichTextEditor.ClearFormatting),
        React.createElement(RichTextEditor.Highlight),
        React.createElement(RichTextEditor.Code),
      ),
      React.createElement(
        RichTextEditor.ControlsGroup,
        null,
        React.createElement(RichTextEditor.H1),
        React.createElement(RichTextEditor.H2),
        React.createElement(RichTextEditor.H3),
        React.createElement(RichTextEditor.H4),
      ),
      React.createElement(
        RichTextEditor.ControlsGroup,
        null,
        React.createElement(RichTextEditor.Blockquote),
        React.createElement(RichTextEditor.Hr),
        React.createElement(RichTextEditor.BulletList),
        React.createElement(RichTextEditor.OrderedList),
      ),
      React.createElement(
        RichTextEditor.ControlsGroup,
        null,
        React.createElement(RichTextEditor.Link),
        React.createElement(RichTextEditor.Unlink),
      ),
      React.createElement(
        RichTextEditor.ControlsGroup,
        null,
        React.createElement(RichTextEditor.AlignLeft),
        React.createElement(RichTextEditor.AlignCenter),
        React.createElement(RichTextEditor.AlignRight),
        React.createElement(RichTextEditor.AlignJustify),
      ),
      React.createElement(
        RichTextEditor.ControlsGroup,
        null,
        React.createElement(RichTextEditor.Undo),
        React.createElement(RichTextEditor.Redo),
      ),
    ),
    React.createElement(RichTextEditor.Content),
  );
}

export const components = { RichTextEditor: ShinyRichTextEditor };
