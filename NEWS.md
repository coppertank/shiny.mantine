# shiny.mantine 0.2.0

Initial public release.

* Updated to Mantine 9.5.1. `FloatingWindow()` gained an optional
  `inputId`: when set, resizing it (via `FloatingWindowResizeHandle()`)
  reports the new size to `input[[inputId]]` (`list(width=, height=)`) and
  fires `input[[paste0(inputId, "_resize_start")]]`/`"_resize_end"` events
  — previously the component had no way to react to resizing server-side.
  Every other 9.5.1 change (`ColorInput(fullWidth=)`,
  `PasswordInput(visibilityToggleFocusable=)`, `Cascader(safeAreaPolygon=)`,
  `ScatterChart`'s second Y axis via `withRightYAxis`/`rightYAxisProps`/
  per-series `yAxisId`, `YearView(withWeekendDays=)`,
  `ResourcesMonthView`'s new `withEventResize` support) already worked with
  no code changes, since these components forward arbitrary props/data
  through unmodified. `YearView`'s new `renderDay` prop is a JS render
  function and is not exposed, consistent with every other `render*` prop
  in the package.
* Updated to Mantine 9.5.0. New components: `Combobox()` (plus its
  compound sub-parts: `ComboboxTarget()`, `ComboboxDropdown()`,
  `ComboboxOptions()`, `ComboboxOption()`, `ComboboxSearch()`, ...) — the
  headless dropdown primitive `Select()`/`MultiSelect()`/`Autocomplete()`/
  `TagsInput()` are built on top of, now wrapped by internally owning
  Mantine's `useCombobox()` store so the R API stays fully declarative;
  `ComboboxPopover()`/`ComboboxPopoverTarget()`; `OverflowList()`;
  `TableOfContents()`; `Cascader()` (hierarchical cascading-column
  selection, added in Mantine 9.5); `FloatingWindowResizeHandle()` (added
  in 9.5); `MonthPicker()`/`YearPicker()` (always-visible inline
  counterparts of `MonthPickerInput()`/`YearPickerInput()`); `TimeValue()`;
  `BarsList()`; `SunburstChart()`/`BulletChart()` (added in 9.5); and
  `DropzoneFullScreen()` (captures drops anywhere in the browser window,
  not just a fixed area).
* Added a full wrapper for the `@mantine/schedule` satellite package (the
  package's 11th): `DayView()`, `WeekView()`, `MonthView()`, `YearView()`,
  `AgendaView()`, `MobileMonthView()`, the resource-grouped
  `ResourcesDayView()`/`ResourcesWeekView()`/`ResourcesMonthView()`
  (including `intervalMinutes` support for multi-hour columns, e.g.
  `intervalMinutes = 240`), and `Schedule()` (a unified view with its own
  day/week/month/year switcher). Events/resources are `data.frame`s (or
  lists of rows) with automatic `Date`/`POSIXct` conversion for
  `start`/`end`; drag-and-drop and resize (`withEventsDragAndDrop`/
  `withEventResize`) update the display immediately and report the change
  to Shiny under a suffixed input id, the same pattern already used by
  `SortableList()`/`SortableTable()`. See `vignette("satellite-packages")`.
* Fixed `RichTextEditor()`'s `Highlight` toolbar button being a dead
  no-op (its Tiptap extension was never registered); added `Subscript`/
  `Superscript`/`TaskList` support and a new `controls` prop to
  customize/trim the toolbar layout.
* Fixed a latent bug where `MultiSelect()`/`TagsInput()`/`CheckboxGroup()`/
  `SwitchGroup()` (and their `update*()` counterparts) would crash if
  given a single-item `value` (e.g. `c("onlyone")`): `jsonlite`'s
  `auto_unbox` collapses a length-1 vector to a bare JSON scalar instead
  of a 1-element array, and each of these calls `.map()` on `value`
  unconditionally on the JS side. Fixed via a new internal `ensureArray()`
  helper, also used by `Cascader()`'s path `value`.
* Every `mantine.dev` page was re-audited against this package's exports
  for the 9.5.0 release; the only remaining gaps are `Calendar()` and
  `FloatingIndicator()` (both need a live DOM ref or function-callback
  prop that can't cross the R/JSON bridge) — see `vignette("core-misc")`'s
  "Intentionally out of scope" section.

* Each of the 10 Mantine satellite packages (dates, notifications, modals,
  spotlight, charts, code-highlight, nprogress, tiptap, dropzone,
  carousel) is now code-split into its own chunk
  (`inst/www/<family>.mantine.js`), dynamically fetched (JS + CSS) the
  first time a component from that family actually mounts, instead of
  bundled unconditionally into `inst/www/mantine.js`. A bare
  `MantineProvider()` app now loads ~1.1 MiB of JS and a single
  `@mantine/core` stylesheet instead of ~2.3 MiB and 11 stylesheets
  (10 satellite packages + core) regardless of which components it
  actually uses. See `js/src/satellites/*.js`, `js/src/lazy.js`, and the
  updated "Known limitations" section of the README.
* R wrappers for the full `@mantine/core` component set (layout,
  typography, navigation, inputs, overlays, data display) plus all ten
  satellite packages: `dates`, `notifications`, `modals`, `spotlight`,
  `charts`, `code-highlight`, `nprogress`, `tiptap`, `dropzone`, and
  `carousel`.
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
* Every page on <https://mantine.dev/core/> was audited against this
  package's exports (comparing this package's exports against every
  `@mantine/core` runtime export, cross-checked against Mantine's own
  documented page list) to close the last three genuinely missing
  components — `Scroller()` (horizontally-scrollable container with
  arrow controls), `FloatingWindow()` (a draggable floating panel), and
  `PillsInput()`/`PillsInputField()` (the multi-value input box
  `MultiSelect()`/`TagsInput()` use internally) — plus a handful of small
  sub-parts rounding out already-covered families: `InputClearButton()`,
  `InputSuccess()`, `PaginationControl()`, `PaginationLabel()`,
  `FocusTrapInitialFocus()`.
* Vignettes restructured around <https://mantine.dev/core/>'s own
  category sidebar: the single `component-gallery` vignette is replaced
  by ten `core-*` vignettes (`core-layout`, `core-inputs`,
  `core-combobox`, `core-buttons`, `core-navigation`, `core-feedback`,
  `core-overlays`, `core-data-display`, `core-typography`, `core-misc`),
  each an R rewrite of the corresponding mantine.dev/core page(s), plus a
  new `extras` vignette for group inputs, drag-and-drop reordering, and
  button recipes that don't have their own mantine.dev/core page.
  `satellite-packages` gained `@mantine/dropzone`/`@mantine/carousel`
  sections that used to live in the removed vignette.

### Bug fixes

* Fixed an echo/ping-pong feedback loop in stateful inputs
  (`TextInput()`/`Slider()`/`Switch()`/...): a server-pushed value via
  `update*()` no longer re-reports itself back to Shiny as if it were a
  fresh user edit, which previously caused erratic/flickering behavior
  when two inputs were kept in sync with a pair of `observeEvent()`s
  (e.g. a `NumberInput()` mirrored to a `Slider()`).
* Fixed `SplitButton()`'s dropdown arrow rendering with mismatched
  border-radius against the primary button.
* Fixed unreadable text in dark mode inside `fluidPage()`/`bootstrapPage()`
  apps: Bootstrap 3's `body { color: #333333; }` has the same specificity
  as, and (loaded later) wins over, Mantine's own `body { color:
  var(--mantine-color-text); }`, permanently pinning every
  Text/Title/Paper/Stepper label (anything that inherits text color rather
  than setting its own) to a fixed dark gray that never adapted to dark
  mode — invisible in light mode, unreadable against dark-mode
  backgrounds. A more specific rule scoped to `.shiny-mantine-container`/
  `.shiny-mantine-output` now wins regardless of stylesheet load order.
* Fixed a Bootstrap 3 CSS leak (`fluidPage()`'s bundled
  `input[type="checkbox"], input[type="radio"] { margin: 4px 0 0 }`
  rule) misaligning the checked icon inside `Checkbox()`/`Radio()`/
  `Switch()`/`Chip()`/`CheckboxCard()`/`RadioCard()` and group items.
* Fixed `@mantine/spotlight`'s CSS being silently dropped from the
  production bundle (its `package.json` declares `"sideEffects": false`
  with no `*.css` exception, unlike `@mantine/core`, so webpack's
  tree-shaking removed the "unused" stylesheet import) — this made
  `SpotlightActionsGroup()`'s `label` never actually render.
