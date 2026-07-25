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
* Compound/composable forms of `Modal()`/`Drawer()`/`Pagination()`/
  `Spotlight()` for fully custom layouts: `ModalRoot()` + `ModalOverlay()`/
  `ModalContent()`/`ModalHeader()`/`ModalTitle()`/`ModalCloseButton()`/
  `ModalBody()` (and the `Drawer*`/`Pagination*`/`Spotlight*` equivalents).
* `HueSlider()`/`AlphaSlider()`/`AngleSlider()` — standalone versions of
  `ColorPicker()`'s channel sliders, plus a circular angle dial.
* The `Input`/`InputBase`/`InputWrapper`/`InputLabel`/`InputDescription`/
  `InputError`/`InputPlaceholder` primitives, `FocusTrap()`/
  `RemoveScroll()`, `MantineThemeProvider()`, `RadioIndicator()`/
  `CheckboxIndicator()`, and small standalone pieces Mantine renders
  internally (`CheckIcon()`, `CloseIcon()`, `AccordionChevron()`,
  `RadioIcon()`, `ActionIconGroupSection()`, `ButtonGroupSection()`).

### Bug fixes

* Fixed an echo/ping-pong feedback loop in stateful inputs
  (`TextInput()`/`Slider()`/`Switch()`/...): a server-pushed value via
  `update*()` no longer re-reports itself back to Shiny as if it were a
  fresh user edit, which previously caused erratic/flickering behavior
  when two inputs were kept in sync with a pair of `observeEvent()`s
  (e.g. a `NumberInput()` mirrored to a `Slider()`).
* Fixed `SplitButton()`'s dropdown arrow rendering with mismatched
  border-radius against the primary button.
* Fixed a Bootstrap 3 CSS leak (`fluidPage()`'s bundled
  `input[type="checkbox"], input[type="radio"] { margin: 4px 0 0 }`
  rule) misaligning the checked icon inside `Checkbox()`/`Radio()`/
  `Switch()`/`Chip()`/`CheckboxCard()`/`RadioCard()` and group items.
* Fixed `@mantine/spotlight`'s CSS being silently dropped from the
  production bundle (its `package.json` declares `"sideEffects": false`
  with no `*.css` exception, unlike `@mantine/core`, so webpack's
  tree-shaking removed the "unused" stylesheet import) — this made
  `SpotlightActionsGroup()`'s `label` never actually render.
