#!/usr/bin/env node
/**
 * Generator for purely "display" Mantine components (no special
 * interaction/state: just props and children passed through as-is).
 *
 * Solves the "no automated generator, everything hand-written" gap: to add
 * a new Mantine component that requires no special logic, add a line to
 * MANIFEST below and re-run:
 *
 *   node scripts/generate-components.js
 *
 * Regenerates:
 *   - js/src/generated-components.js  (import + registry object from @mantine/core)
 *   - R/generated-components.R        (R wrappers with roxygen docs, one per name)
 *
 * Components with real interaction (stateful inputs, anchored dropdowns,
 * controllable overlays, ...) keep being hand-written elsewhere (see
 * R/Inputs2.R, R/Sliders.R, R/Overlays.R, ...): this generator only covers
 * the "props/children passthrough" case, which is the majority of the
 * components that would otherwise be missing.
 */

const fs = require('fs');
const path = require('path');

// Each entry: { name: <@mantine/core export>, doc: <short description>,
// slug: <mantine.dev docs page slug>, compound: [{ export, jsName }] for
// sub-parts such as List.Item }.
const MANIFEST = [
  { name: 'AspectRatio', slug: 'aspect-ratio', doc: 'Keeps a fixed width/height ratio for its content' },
  { name: 'Flex', slug: 'flex', doc: 'Flexbox container with shorthand props (direction, gap, wrap, align, justify)' },
  { name: 'Space', slug: 'space', doc: 'Empty horizontal/vertical spacer' },
  { name: 'BackgroundImage', slug: 'background-image', doc: 'Container with a background image' },
  { name: 'Blockquote', slug: 'blockquote', doc: 'Styled quotation block' },
  { name: 'Code', slug: 'code', doc: 'Inline or block code-styled text' },
  { name: 'Highlight', slug: 'highlight', doc: 'Text with highlighted parts (`highlight` prop)' },
  {
    name: 'List',
    slug: 'list',
    doc: 'Bulleted/numbered list',
    compound: [{ export: 'ListItem', jsName: 'Item' }],
  },
  { name: 'Mark', slug: 'mark', doc: 'Highlighted text (`<mark>` tag)' },
  { name: 'CloseButton', slug: 'close-button', doc: '"x" icon button for closing/removing' },
  { name: 'Alert', slug: 'alert', doc: 'Warning banner with icon/title/color' },
  { name: 'Loader', slug: 'loader', doc: 'Loading indicator (spinner)' },
  { name: 'Skeleton', slug: 'skeleton', doc: 'Animated placeholder for loading content' },
  { name: 'ColorSwatch', slug: 'color-swatch', doc: 'Small color sample' },
  { name: 'Indicator', slug: 'indicator', doc: 'Badge/dot positioned over an element (e.g. unread notifications)' },
  { name: 'Kbd', slug: 'kbd', doc: 'Keyboard-key-styled text' },
  { name: 'Spoiler', slug: 'spoiler', doc: 'Truncated content with a "show more" toggle' },
  {
    name: 'Timeline',
    slug: 'timeline',
    doc: 'Vertical sequence of events',
    compound: [{ export: 'TimelineItem', jsName: 'Item' }],
  },
  { name: 'AvatarGroup', slug: 'avatar', doc: 'Groups several overlapping Avatars' },
  { name: 'Overlay', slug: 'overlay', doc: 'Semi-transparent layer over some content' },
  { name: 'Breadcrumbs', slug: 'breadcrumbs', doc: 'Navigation trail (Home > Section > Page)' },
  { name: 'Fieldset', slug: 'fieldset', doc: 'Groups form inputs under a legend' },
  {
    name: 'DataList',
    slug: 'data-list',
    doc: 'Key/value list (definition-list style)',
    compound: [
      { export: 'DataListItem', jsName: 'Item' },
      { export: 'DataListItemLabel', jsName: 'ItemLabel' },
      { export: 'DataListItemValue', jsName: 'ItemValue' },
    ],
  },
  {
    name: 'EmptyState',
    slug: 'empty-state',
    doc: 'Placeholder shown when there is no content to display',
    compound: [
      { export: 'EmptyStateActions', jsName: 'Actions' },
      { export: 'EmptyStateDescription', jsName: 'Description' },
      { export: 'EmptyStateIndicator', jsName: 'Indicator' },
      { export: 'EmptyStateTitle', jsName: 'Title' },
    ],
  },
  { name: 'Marquee', slug: 'marquee', doc: 'Horizontally scrolling ticker of content' },
  { name: 'NumberFormatter', slug: 'number-formatter', doc: 'Formats a numeric value as display text (thousand separators, decimals, prefix/suffix)' },
  {
    name: 'Pill',
    slug: 'pill',
    doc: 'Small rounded tag/chip element',
    compound: [{ export: 'PillGroup', jsName: 'Group' }],
  },
  { name: 'RollingNumber', slug: 'rolling-number', doc: 'Animated rolling/odometer-style number display' },
  { name: 'SemiCircleProgress', slug: 'semi-circle-progress', doc: 'Half-circle progress indicator' },
  { name: 'TooltipFloating', slug: 'tooltip', doc: 'Tooltip that follows the cursor instead of anchoring to the target' },
  { name: 'TooltipGroup', slug: 'tooltip', doc: 'Shares open/close delay behaviour across a group of Tooltips' },
  { name: 'Typography', slug: 'typography', doc: 'Applies Mantine\'s prose/typography styling to arbitrary HTML content (e.g. rendered Markdown)' },
  { name: 'VisuallyHidden', slug: 'visually-hidden', doc: 'Visually hides content while keeping it available to screen readers' },

  // Modal.* / Drawer.* compound parts - purely structural pieces behind
  // Modal()/Drawer(); ModalRoot()/DrawerRoot() (the stateful piece that
  // replaces the compound's own Root) are hand-written in R/Overlays.R.
  { name: 'ModalOverlay', slug: 'modal', doc: 'Dimmed backdrop behind a ModalRoot()' },
  { name: 'ModalContent', slug: 'modal', doc: 'Content box of a ModalRoot() (holds ModalHeader()/ModalBody())' },
  { name: 'ModalHeader', slug: 'modal', doc: 'Header row of a ModalRoot() (usually ModalTitle() + ModalCloseButton())' },
  { name: 'ModalTitle', slug: 'modal', doc: 'Title text of a ModalRoot()' },
  { name: 'ModalCloseButton', slug: 'modal', doc: 'Close ("x") button of a ModalRoot() - already wired to its onClose' },
  { name: 'ModalBody', slug: 'modal', doc: 'Body/content area of a ModalRoot()' },
  { name: 'DrawerOverlay', slug: 'drawer', doc: 'Dimmed backdrop behind a DrawerRoot()' },
  { name: 'DrawerContent', slug: 'drawer', doc: 'Content box of a DrawerRoot() (holds DrawerHeader()/DrawerBody())' },
  { name: 'DrawerHeader', slug: 'drawer', doc: 'Header row of a DrawerRoot() (usually DrawerTitle() + DrawerCloseButton())' },
  { name: 'DrawerTitle', slug: 'drawer', doc: 'Title text of a DrawerRoot()' },
  { name: 'DrawerCloseButton', slug: 'drawer', doc: 'Close ("x") button of a DrawerRoot() - already wired to its onClose' },
  { name: 'DrawerBody', slug: 'drawer', doc: 'Body/content area of a DrawerRoot()' },

  // Pagination.* compound parts - purely structural/self-wired pieces
  // behind PaginationRoot() (hand-written in R/SpecialInputs.R), reading
  // the current page from it automatically - no props needed.
  { name: 'PaginationItems', slug: 'pagination', doc: 'Numbered page buttons of a PaginationRoot()' },
  { name: 'PaginationFirst', slug: 'pagination', doc: '"Go to first page" button of a PaginationRoot()' },
  { name: 'PaginationLast', slug: 'pagination', doc: '"Go to last page" button of a PaginationRoot()' },
  { name: 'PaginationNext', slug: 'pagination', doc: '"Go to next page" button of a PaginationRoot()' },
  { name: 'PaginationPrevious', slug: 'pagination', doc: '"Go to previous page" button of a PaginationRoot()' },
  { name: 'PaginationDots', slug: 'pagination', doc: 'Ellipsis ("...") separator of a PaginationRoot()' },

  // Input primitives - the styled box (border, focus ring, sections) and
  // label/description/error chrome every stateful input in this package
  // already uses internally, exposed for building fully custom inputs.
  // Unlike TextInput()/etc., these are NOT synced to Shiny on their own.
  { name: 'Input', slug: 'input', doc: 'Styled input box (border, focus ring, left/right sections) with no value/onChange management of its own' },
  { name: 'InputBase', slug: 'input', doc: 'Like Input(), extended with a few more style-composition options used internally by other inputs' },
  { name: 'InputWrapper', slug: 'input', doc: 'Label/description/error/required-asterisk chrome around arbitrary custom content' },
  { name: 'InputLabel', slug: 'input', doc: 'Standalone input label, styled like InputWrapper()\'s own label' },
  { name: 'InputDescription', slug: 'input', doc: 'Standalone input description text, styled like InputWrapper()\'s own description' },
  { name: 'InputError', slug: 'input', doc: 'Standalone input error text, styled like InputWrapper()\'s own error' },
  { name: 'InputPlaceholder', slug: 'input', doc: 'Renders its children with input-placeholder styling (dimmed text)' },

  // Focus/scroll primitives used internally by Modal()/Drawer(), exposed
  // for building fully custom overlays with ModalRoot()/DrawerRoot().
  { name: 'FocusTrap', slug: 'focus-trap', doc: 'Traps keyboard focus inside its single child while active' },
  { name: 'RemoveScroll', slug: 'floating', doc: 'Prevents the page behind it from scrolling while enabled' },

  // Updates the theme *object* available to custom code that explicitly
  // calls Mantine's useMantineTheme() hook - it does NOT re-inject the
  // CSS variables standard pre-styled components (Button, Badge, ...)
  // actually read their colors from (those come from the CSS variables
  // the outermost MantineProvider() sets once), so nesting one does not
  // visually restyle standard components. Included for completeness/API
  // parity; narrow practical use in shiny.mantine specifically.
  { name: 'MantineThemeProvider', slug: 'mantine-provider', doc: 'Updates the theme object exposed via Mantine\'s useMantineTheme() hook for custom code - does NOT restyle standard components, see the note in `?MantineThemeProvider`' },

  // Small standalone pieces Mantine renders internally (icons/sections),
  // exposed for reuse - not from '@tabler/icons-react' (see `?icons`).
  { name: 'CheckIcon', slug: 'checkbox', doc: 'The checkmark icon Checkbox()/CheckboxCard() render when checked' },
  { name: 'CloseIcon', slug: 'close-button', doc: 'The "x" icon CloseButton() renders' },
  { name: 'AccordionChevron', slug: 'accordion', doc: 'The chevron icon Accordion() renders next to each control' },
  { name: 'RadioIcon', slug: 'radio', doc: 'The dot icon Radio()/RadioCard() render when checked' },
  { name: 'ActionIconGroupSection', slug: 'action-icon', doc: 'Non-interactive section (e.g. a label) placed between grouped ActionIcon()s' },
  { name: 'ButtonGroupSection', slug: 'button', doc: 'Non-interactive section (e.g. a label) placed between grouped Button()s' },

  // Gaps found auditing every documented page on mantine.dev/core against
  // this package's exports (see the "Mantine core coverage" vignette
  // section): the only three genuinely missing top-level pages, plus a
  // few small, simple (BoxProps-only, no required function/ref props)
  // sub-parts that round out families already covered above.
  {
    name: 'PillsInput',
    slug: 'pills-input',
    doc: 'Styled input box for a list of Pill()s plus a text field, the multi-value building block MultiSelect()/TagsInput() use internally',
    compound: [{ export: 'PillsInputField', jsName: 'Field' }],
  },
  { name: 'Scroller', slug: 'scroller', doc: 'Horizontally scrollable container with prev/next arrow controls (e.g. for a row of chips/thumbnails)' },
  { name: 'FloatingWindow', slug: 'floating-window', doc: 'A draggable floating panel positioned anywhere in the viewport (drag to move; position is not updatable from the server once mounted)' },
  { name: 'InputClearButton', slug: 'input', doc: 'The "x" clear button Select()/DatePickerInput()/etc. render when clearable, exposed for custom inputs built on Input()' },
  { name: 'InputSuccess', slug: 'input', doc: 'Standalone input success text, styled like the internal success state of stateful inputs' },
  { name: 'PaginationControl', slug: 'pagination', doc: 'Generic clickable pagination-styled button, for building entirely custom page controls inside PaginationRoot()' },
  { name: 'PaginationLabel', slug: 'pagination', doc: 'The compact "page X of Y" label PaginationRoot() shows in its `layout = "responsive"` mode' },
  { name: 'FocusTrapInitialFocus', slug: 'focus-trap', doc: 'Invisible marker: the first focusable element FocusTrap() should focus, if not the first one in DOM order' },

  // Fourth coverage pass (re-diffed against every documented mantine.dev
  // page, since mantine.dev/core grew a handful of pages since the third
  // pass above): Combobox/ComboboxPopover/OverflowList/TableOfContents
  // all need custom JS logic (an internally-owned useCombobox() store, a
  // children->data adapter, a hardcoded getControlProps), so they're
  // hand-written directly in js/src/index.js (R/Combobox.R,
  // R/OverflowList.R, R/TableOfContents.R) rather than added here - this
  // generator only covers pure props/children passthrough. Calendar and
  // FloatingIndicator remain unwrapped (see the "Intentionally out of
  // scope" vignette section) - the former needs a `getDayProps` render
  // callback and the latter a live DOM element `ref`, neither expressible
  // as JSON-serializable R props.
];

const jsImportNames = MANIFEST.flatMap((c) => [c.name, ...(c.compound || []).map((s) => s.export)]);

const jsRegistryLines = MANIFEST.flatMap((c) => {
  const lines = [`  ${c.name},`];
  (c.compound || []).forEach((s) => {
    lines.push(`  '${c.name}.${s.jsName}': ${s.export},`);
  });
  return lines;
});

const jsOut = `// Auto-generated by js/scripts/generate-components.js
// DO NOT EDIT BY HAND — edit MANIFEST there instead and re-run the script.
import {
  ${jsImportNames.join(',\n  ')},
} from '@mantine/core';

// Merged into the main registry in index.js, each wrapped in
// withReactiveProps() to support updateMantineProps().
export const generatedComponents = {
${jsRegistryLines.join('\n')}
};
`;

const rBlocks = MANIFEST.map((c) => {
  const lines = [
    '#\' @rdname ' + c.name,
    `#' @param ... Props and children. See <https://mantine.dev/core/${c.slug}/>.`,
    "#' @export",
    `${c.name} <- displayComponent("${c.name}")`,
  ];
  const header = [
    `#' Mantine ${c.name}`,
    '#\'',
    `#' ${c.doc}. Supports \`mantineId\` for reactive updates via`,
    "#' [updateMantineProps()].",
  ];
  const compoundLines = (c.compound || []).map((s) => [
    '',
    `#' @rdname ${c.name}`,
    "#' @export",
    `${c.name}${s.jsName} <- displayComponent("${c.name}.${s.jsName}")`,
  ].join('\n'));
  return [...header, ...lines, ...compoundLines].join('\n');
});

const rOut = `# Auto-generated by js/scripts/generate-components.js
# DO NOT EDIT BY HAND — edit MANIFEST there instead and re-run the script.

#' @include mantine-element.R
NULL

${rBlocks.join('\n\n')}
`;

fs.writeFileSync(path.join(__dirname, '..', 'src', 'generated-components.js'), jsOut);
fs.writeFileSync(path.join(__dirname, '..', '..', 'R', 'generated-components.R'), rOut);

console.log(`Generated ${MANIFEST.length} components (+ ${MANIFEST.reduce((n, c) => n + (c.compound || []).length, 0)} sub-parts):`);
console.log('  js/src/generated-components.js');
console.log('  R/generated-components.R');
