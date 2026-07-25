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
* `ModalStack()`/`DrawerStack()` — coordinated stacks of `Modal()`/
  `Drawer()`s (layered z-index, focus trapping, `closeAll()`), opened and
  closed with the same `updateMantineProps()` calls as a standalone one.
* Its own bundled React 19 runtime, independent from `shiny.react`'s
  shared React 18 runtime, required for compatibility with Mantine v9.
* A runnable demo app per [ui.mantine.dev](https://ui.mantine.dev/)
  category under `inst/examples/`.

### Bug fixes

* Fixed an echo/ping-pong feedback loop in stateful inputs
  (`TextInput()`/`Slider()`/`Switch()`/...): a server-pushed value via
  `update*()` no longer re-reports itself back to Shiny as if it were a
  fresh user edit, which previously caused erratic/flickering behavior
  when two inputs were kept in sync with a pair of `observeEvent()`s
  (e.g. a `NumberInput()` mirrored to a `Slider()`).
* Fixed `SplitButton()`'s dropdown arrow rendering with mismatched
  border-radius against the primary button.
