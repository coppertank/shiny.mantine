# shiny.mantine 0.2.0

Initial public release.

* R wrappers for the full `@mantine/core` component set (layout,
  typography, navigation, inputs, overlays, data display) plus all eight
  satellite packages: `dates`, `notifications`, `modals`, `spotlight`,
  `charts`, `code-highlight`, `nprogress`, and `tiptap`.
* A client-side page router (`Pages()`/`Page()`).
* A generic reactive-props update channel (`updateMantineProps()`) for
  updating any component prop from the server, not just an input's value.
* A `renderUI()`-equivalent reactive output for Mantine content
  (`mantineOutput()`/`renderMantine()`).
* Its own bundled React 19 runtime, independent from `shiny.react`'s
  shared React 18 runtime, required for compatibility with Mantine v9.
* A runnable demo app per [ui.mantine.dev](https://ui.mantine.dev/)
  category under `inst/examples/`.
