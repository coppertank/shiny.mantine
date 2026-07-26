import React from 'react';
import {
  CodeHighlight, InlineCodeHighlight, CodeHighlightTabs, CodeHighlightAdapterProvider, plainTextAdapter,
} from '@mantine/code-highlight';
import '@mantine/code-highlight/styles.css';
import { withReactiveProps } from '../shared';

// CodeHighlight requires a syntax-highlighting "adapter"
// (highlight.js/shiki, not included to avoid bloating the bundle): always
// use plainTextAdapter (no colors, but no extra dependencies) so the
// component works out of the box with no extra setup.
function ShinyCodeHighlight(props) {
  return React.createElement(
    CodeHighlightAdapterProvider,
    { adapter: plainTextAdapter },
    React.createElement(CodeHighlight, props),
  );
}

function ShinyInlineCodeHighlight(props) {
  return React.createElement(
    CodeHighlightAdapterProvider,
    { adapter: plainTextAdapter },
    React.createElement(InlineCodeHighlight, props),
  );
}

function ShinyCodeHighlightTabs(props) {
  return React.createElement(
    CodeHighlightAdapterProvider,
    { adapter: plainTextAdapter },
    React.createElement(CodeHighlightTabs, props),
  );
}

export const components = {
  CodeHighlight: withReactiveProps(ShinyCodeHighlight),
  InlineCodeHighlight: withReactiveProps(ShinyInlineCodeHighlight),
  CodeHighlightTabs: withReactiveProps(ShinyCodeHighlightTabs),
};
