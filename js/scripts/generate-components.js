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
