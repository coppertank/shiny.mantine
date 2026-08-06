# Changelog

## shiny.mantine 0.2.0

Initial public release.

- Updated to Mantine 9.5.1.
  [`FloatingWindow()`](https://coppertank.github.io/shiny.mantine/reference/FloatingWindow.md)
  gained an optional `inputId`: when set, resizing it (via
  [`FloatingWindowResizeHandle()`](https://coppertank.github.io/shiny.mantine/reference/FloatingWindow.md))
  reports the new size to `input[[inputId]]` (`list(width=, height=)`)
  and fires `input[[paste0(inputId, "_resize_start")]]`/`"_resize_end"`
  events — previously the component had no way to react to resizing
  server-side. Every other 9.5.1 change (`ColorInput(fullWidth=)`,
  `PasswordInput(visibilityToggleFocusable=)`,
  `Cascader(safeAreaPolygon=)`, `ScatterChart`’s second Y axis via
  `withRightYAxis`/`rightYAxisProps`/ per-series `yAxisId`,
  `YearView(withWeekendDays=)`, `ResourcesMonthView`’s new
  `withEventResize` support) already worked with no code changes, since
  these components forward arbitrary props/data through unmodified.
  `YearView`’s new `renderDay` prop is a JS render function and is not
  exposed, consistent with every other `render*` prop in the package.

- Updated to Mantine 9.5.0. New components:
  [`Combobox()`](https://coppertank.github.io/shiny.mantine/reference/Combobox.md)
  (plus its compound sub-parts:
  [`ComboboxTarget()`](https://coppertank.github.io/shiny.mantine/reference/Combobox.md),
  [`ComboboxDropdown()`](https://coppertank.github.io/shiny.mantine/reference/Combobox.md),
  [`ComboboxOptions()`](https://coppertank.github.io/shiny.mantine/reference/Combobox.md),
  [`ComboboxOption()`](https://coppertank.github.io/shiny.mantine/reference/Combobox.md),
  [`ComboboxSearch()`](https://coppertank.github.io/shiny.mantine/reference/Combobox.md),
  …) — the headless dropdown primitive
  [`Select()`](https://coppertank.github.io/shiny.mantine/reference/Select.md)/[`MultiSelect()`](https://coppertank.github.io/shiny.mantine/reference/MultiSelect.md)/[`Autocomplete()`](https://coppertank.github.io/shiny.mantine/reference/Autocomplete.md)/
  [`TagsInput()`](https://coppertank.github.io/shiny.mantine/reference/TagsInput.md)
  are built on top of, now wrapped by internally owning Mantine’s
  `useCombobox()` store so the R API stays fully declarative;
  [`ComboboxPopover()`](https://coppertank.github.io/shiny.mantine/reference/ComboboxPopover.md)/[`ComboboxPopoverTarget()`](https://coppertank.github.io/shiny.mantine/reference/ComboboxPopover.md);
  [`OverflowList()`](https://coppertank.github.io/shiny.mantine/reference/OverflowList.md);
  [`TableOfContents()`](https://coppertank.github.io/shiny.mantine/reference/TableOfContents.md);
  [`Cascader()`](https://coppertank.github.io/shiny.mantine/reference/Cascader.md)
  (hierarchical cascading-column selection, added in Mantine 9.5);
  [`FloatingWindowResizeHandle()`](https://coppertank.github.io/shiny.mantine/reference/FloatingWindow.md)
  (added in 9.5);
  [`MonthPicker()`](https://coppertank.github.io/shiny.mantine/reference/MonthPicker.md)/[`YearPicker()`](https://coppertank.github.io/shiny.mantine/reference/YearPicker.md)
  (always-visible inline counterparts of
  [`MonthPickerInput()`](https://coppertank.github.io/shiny.mantine/reference/MonthPickerInput.md)/[`YearPickerInput()`](https://coppertank.github.io/shiny.mantine/reference/YearPickerInput.md));
  [`TimeValue()`](https://coppertank.github.io/shiny.mantine/reference/TimeValue.md);
  [`BarsList()`](https://coppertank.github.io/shiny.mantine/reference/BarsList.md);
  [`SunburstChart()`](https://coppertank.github.io/shiny.mantine/reference/SunburstChart.md)/[`BulletChart()`](https://coppertank.github.io/shiny.mantine/reference/BulletChart.md)
  (added in 9.5); and
  [`DropzoneFullScreen()`](https://coppertank.github.io/shiny.mantine/reference/Dropzone.md)
  (captures drops anywhere in the browser window, not just a fixed
  area).

- Added a full wrapper for the `@mantine/schedule` satellite package
  (the package’s 11th):
  [`DayView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md),
  [`WeekView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md),
  [`MonthView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md),
  [`YearView()`](https://coppertank.github.io/shiny.mantine/reference/ScheduleViews.md),
  [`AgendaView()`](https://coppertank.github.io/shiny.mantine/reference/AgendaView.md),
  [`MobileMonthView()`](https://coppertank.github.io/shiny.mantine/reference/MobileMonthView.md),
  the resource-grouped
  [`ResourcesDayView()`](https://coppertank.github.io/shiny.mantine/reference/ResourcesScheduleViews.md)/[`ResourcesWeekView()`](https://coppertank.github.io/shiny.mantine/reference/ResourcesScheduleViews.md)/[`ResourcesMonthView()`](https://coppertank.github.io/shiny.mantine/reference/ResourcesScheduleViews.md)
  (including `intervalMinutes` support for multi-hour columns, e.g.
  `intervalMinutes = 240`), and
  [`Schedule()`](https://coppertank.github.io/shiny.mantine/reference/Schedule.md)
  (a unified view with its own day/week/month/year switcher).
  Events/resources are `data.frame`s (or lists of rows) with automatic
  `Date`/`POSIXct` conversion for `start`/`end`; drag-and-drop and
  resize (`withEventsDragAndDrop`/ `withEventResize`) update the display
  immediately and report the change to Shiny under a suffixed input id,
  the same pattern already used by
  [`SortableList()`](https://coppertank.github.io/shiny.mantine/reference/SortableList.md)/[`SortableTable()`](https://coppertank.github.io/shiny.mantine/reference/SortableTable.md).
  See
  [`vignette("satellite-packages")`](https://coppertank.github.io/shiny.mantine/articles/satellite-packages.md).

- Fixed
  [`RichTextEditor()`](https://coppertank.github.io/shiny.mantine/reference/RichTextEditor.md)’s
  `Highlight` toolbar button being a dead no-op (its Tiptap extension
  was never registered); added `Subscript`/ `Superscript`/`TaskList`
  support and a new `controls` prop to customize/trim the toolbar
  layout.

- Fixed a latent bug where
  [`MultiSelect()`](https://coppertank.github.io/shiny.mantine/reference/MultiSelect.md)/[`TagsInput()`](https://coppertank.github.io/shiny.mantine/reference/TagsInput.md)/[`CheckboxGroup()`](https://coppertank.github.io/shiny.mantine/reference/CheckboxGroup.md)/
  [`SwitchGroup()`](https://coppertank.github.io/shiny.mantine/reference/SwitchGroup.md)
  (and their `update*()` counterparts) would crash if given a
  single-item `value` (e.g. `c("onlyone")`): `jsonlite`’s `auto_unbox`
  collapses a length-1 vector to a bare JSON scalar instead of a
  1-element array, and each of these calls `.map()` on `value`
  unconditionally on the JS side. Fixed via a new internal
  [`ensureArray()`](https://coppertank.github.io/shiny.mantine/reference/ensureArray.md)
  helper, also used by
  [`Cascader()`](https://coppertank.github.io/shiny.mantine/reference/Cascader.md)’s
  path `value`.

- Every `mantine.dev` page was re-audited against this package’s exports
  for the 9.5.0 release; the only remaining gaps are `Calendar()` and
  `FloatingIndicator()` (both need a live DOM ref or function-callback
  prop that can’t cross the R/JSON bridge) — see
  [`vignette("core-misc")`](https://coppertank.github.io/shiny.mantine/articles/core-misc.md)’s
  “Intentionally out of scope” section.

- Each of the 10 Mantine satellite packages (dates, notifications,
  modals, spotlight, charts, code-highlight, nprogress, tiptap,
  dropzone, carousel) is now code-split into its own chunk
  (`inst/www/<family>.mantine.js`), dynamically fetched (JS + CSS) the
  first time a component from that family actually mounts, instead of
  bundled unconditionally into `inst/www/mantine.js`. A bare
  [`MantineProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineProvider.md)
  app now loads ~1.1 MiB of JS and a single `@mantine/core` stylesheet
  instead of ~2.3 MiB and 11 stylesheets (10 satellite packages + core)
  regardless of which components it actually uses. See
  `js/src/satellites/*.js`, `js/src/lazy.js`, and the updated “Known
  limitations” section of the README.

- R wrappers for the full `@mantine/core` component set (layout,
  typography, navigation, inputs, overlays, data display) plus all ten
  satellite packages: `dates`, `notifications`, `modals`, `spotlight`,
  `charts`, `code-highlight`, `nprogress`, `tiptap`, `dropzone`, and
  `carousel`.

- A client-side page router
  ([`Pages()`](https://coppertank.github.io/shiny.mantine/reference/Pages.md)/[`Page()`](https://coppertank.github.io/shiny.mantine/reference/Pages.md)).

- A generic reactive-props update channel
  ([`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md))
  for updating any component prop from the server, not just an input’s
  value.

- A
  [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html)-equivalent
  reactive output for Mantine content
  ([`mantineOutput()`](https://coppertank.github.io/shiny.mantine/reference/mantineOutput.md)/[`renderMantine()`](https://coppertank.github.io/shiny.mantine/reference/mantineOutput.md)).

- [`ModalStack()`](https://coppertank.github.io/shiny.mantine/reference/ModalStack.md)/[`DrawerStack()`](https://coppertank.github.io/shiny.mantine/reference/DrawerStack.md)
  — coordinated stacks of
  [`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md)/
  [`Drawer()`](https://coppertank.github.io/shiny.mantine/reference/Drawer.md)s
  (layered z-index, focus trapping, `closeAll()`), opened and closed
  with the same
  [`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md)
  calls as a standalone one.

- Its own bundled React 19 runtime, independent from `shiny.react`’s
  shared React 18 runtime, required for compatibility with Mantine v9.

- A runnable demo app per [ui.mantine.dev](https://ui.mantine.dev/)
  category under `inst/examples/`.

- Compound/composable forms of
  [`Modal()`](https://coppertank.github.io/shiny.mantine/reference/Modal.md)/[`Drawer()`](https://coppertank.github.io/shiny.mantine/reference/Drawer.md)/[`Pagination()`](https://coppertank.github.io/shiny.mantine/reference/Pagination.md)/
  [`Spotlight()`](https://coppertank.github.io/shiny.mantine/reference/Spotlight.md)
  for fully custom layouts:
  [`ModalRoot()`](https://coppertank.github.io/shiny.mantine/reference/ModalRoot.md) +
  [`ModalOverlay()`](https://coppertank.github.io/shiny.mantine/reference/ModalOverlay.md)/
  [`ModalContent()`](https://coppertank.github.io/shiny.mantine/reference/ModalContent.md)/[`ModalHeader()`](https://coppertank.github.io/shiny.mantine/reference/ModalHeader.md)/[`ModalTitle()`](https://coppertank.github.io/shiny.mantine/reference/ModalTitle.md)/[`ModalCloseButton()`](https://coppertank.github.io/shiny.mantine/reference/ModalCloseButton.md)/
  [`ModalBody()`](https://coppertank.github.io/shiny.mantine/reference/ModalBody.md)
  (and the `Drawer*`/`Pagination*`/`Spotlight*` equivalents).

- [`HueSlider()`](https://coppertank.github.io/shiny.mantine/reference/HueSlider.md)/[`AlphaSlider()`](https://coppertank.github.io/shiny.mantine/reference/AlphaSlider.md)/[`AngleSlider()`](https://coppertank.github.io/shiny.mantine/reference/AngleSlider.md)
  — standalone versions of
  [`ColorPicker()`](https://coppertank.github.io/shiny.mantine/reference/ColorPicker.md)’s
  channel sliders, plus a circular angle dial.

- The
  `Input`/`InputBase`/`InputWrapper`/`InputLabel`/`InputDescription`/
  `InputError`/`InputPlaceholder` primitives,
  [`FocusTrap()`](https://coppertank.github.io/shiny.mantine/reference/FocusTrap.md)/
  [`RemoveScroll()`](https://coppertank.github.io/shiny.mantine/reference/RemoveScroll.md),
  [`MantineThemeProvider()`](https://coppertank.github.io/shiny.mantine/reference/MantineThemeProvider.md),
  [`RadioIndicator()`](https://coppertank.github.io/shiny.mantine/reference/RadioIndicator.md)/
  [`CheckboxIndicator()`](https://coppertank.github.io/shiny.mantine/reference/RadioIndicator.md),
  and small standalone pieces Mantine renders internally
  ([`CheckIcon()`](https://coppertank.github.io/shiny.mantine/reference/CheckIcon.md),
  [`CloseIcon()`](https://coppertank.github.io/shiny.mantine/reference/CloseIcon.md),
  [`AccordionChevron()`](https://coppertank.github.io/shiny.mantine/reference/AccordionChevron.md),
  [`RadioIcon()`](https://coppertank.github.io/shiny.mantine/reference/RadioIcon.md),
  [`ActionIconGroupSection()`](https://coppertank.github.io/shiny.mantine/reference/ActionIconGroupSection.md),
  [`ButtonGroupSection()`](https://coppertank.github.io/shiny.mantine/reference/ButtonGroupSection.md)).

- Every page on <https://mantine.dev/core/> was audited against this
  package’s exports (comparing this package’s exports against every
  `@mantine/core` runtime export, cross-checked against Mantine’s own
  documented page list) to close the last three genuinely missing
  components —
  [`Scroller()`](https://coppertank.github.io/shiny.mantine/reference/Scroller.md)
  (horizontally-scrollable container with arrow controls),
  [`FloatingWindow()`](https://coppertank.github.io/shiny.mantine/reference/FloatingWindow.md)
  (a draggable floating panel), and
  [`PillsInput()`](https://coppertank.github.io/shiny.mantine/reference/PillsInput.md)/[`PillsInputField()`](https://coppertank.github.io/shiny.mantine/reference/PillsInput.md)
  (the multi-value input box
  [`MultiSelect()`](https://coppertank.github.io/shiny.mantine/reference/MultiSelect.md)/[`TagsInput()`](https://coppertank.github.io/shiny.mantine/reference/TagsInput.md)
  use internally) — plus a handful of small sub-parts rounding out
  already-covered families:
  [`InputClearButton()`](https://coppertank.github.io/shiny.mantine/reference/InputClearButton.md),
  [`InputSuccess()`](https://coppertank.github.io/shiny.mantine/reference/InputSuccess.md),
  [`PaginationControl()`](https://coppertank.github.io/shiny.mantine/reference/PaginationControl.md),
  [`PaginationLabel()`](https://coppertank.github.io/shiny.mantine/reference/PaginationLabel.md),
  [`FocusTrapInitialFocus()`](https://coppertank.github.io/shiny.mantine/reference/FocusTrapInitialFocus.md).

- Vignettes restructured around <https://mantine.dev/core/>’s own
  category sidebar: the single `component-gallery` vignette is replaced
  by ten `core-*` vignettes (`core-layout`, `core-inputs`,
  `core-combobox`, `core-buttons`, `core-navigation`, `core-feedback`,
  `core-overlays`, `core-data-display`, `core-typography`, `core-misc`),
  each an R rewrite of the corresponding mantine.dev/core page(s), plus
  a new `extras` vignette for group inputs, drag-and-drop reordering,
  and button recipes that don’t have their own mantine.dev/core page.
  `satellite-packages` gained `@mantine/dropzone`/`@mantine/carousel`
  sections that used to live in the removed vignette.

#### Bug fixes

- Fixed an echo/ping-pong feedback loop in stateful inputs
  ([`TextInput()`](https://coppertank.github.io/shiny.mantine/reference/TextInput.md)/[`Slider()`](https://coppertank.github.io/shiny.mantine/reference/Slider.md)/[`Switch()`](https://coppertank.github.io/shiny.mantine/reference/Switch.md)/…):
  a server-pushed value via `update*()` no longer re-reports itself back
  to Shiny as if it were a fresh user edit, which previously caused
  erratic/flickering behavior when two inputs were kept in sync with a
  pair of
  [`observeEvent()`](https://rdrr.io/pkg/shiny/man/observeEvent.html)s
  (e.g. a
  [`NumberInput()`](https://coppertank.github.io/shiny.mantine/reference/NumberInput.md)
  mirrored to a
  [`Slider()`](https://coppertank.github.io/shiny.mantine/reference/Slider.md)).
- Fixed
  [`SplitButton()`](https://coppertank.github.io/shiny.mantine/reference/SplitButton.md)’s
  dropdown arrow rendering with mismatched border-radius against the
  primary button.
- Fixed unreadable text in dark mode inside
  [`fluidPage()`](https://rdrr.io/pkg/shiny/man/fluidPage.html)/[`bootstrapPage()`](https://rdrr.io/pkg/shiny/man/bootstrapPage.html)
  apps: Bootstrap 3’s
  `body { color: `[`#333333`](https://github.com/coppertank/shiny.mantine/issues/333333)`; }`
  has the same specificity as, and (loaded later) wins over, Mantine’s
  own `body { color: var(--mantine-color-text); }`, permanently pinning
  every Text/Title/Paper/Stepper label (anything that inherits text
  color rather than setting its own) to a fixed dark gray that never
  adapted to dark mode — invisible in light mode, unreadable against
  dark-mode backgrounds. A more specific rule scoped to
  `.shiny-mantine-container`/ `.shiny-mantine-output` now wins
  regardless of stylesheet load order.
- Fixed a Bootstrap 3 CSS leak
  ([`fluidPage()`](https://rdrr.io/pkg/shiny/man/fluidPage.html)’s
  bundled
  `input[type="checkbox"], input[type="radio"] { margin: 4px 0 0 }`
  rule) misaligning the checked icon inside
  [`Checkbox()`](https://coppertank.github.io/shiny.mantine/reference/Checkbox.md)/[`Radio()`](https://coppertank.github.io/shiny.mantine/reference/RadioGroup.md)/
  [`Switch()`](https://coppertank.github.io/shiny.mantine/reference/Switch.md)/[`Chip()`](https://coppertank.github.io/shiny.mantine/reference/ChipGroup.md)/[`CheckboxCard()`](https://coppertank.github.io/shiny.mantine/reference/CheckboxCard.md)/[`RadioCard()`](https://coppertank.github.io/shiny.mantine/reference/CheckboxCard.md)
  and group items.
- Fixed `@mantine/spotlight`’s CSS being silently dropped from the
  production bundle (its `package.json` declares `"sideEffects": false`
  with no `*.css` exception, unlike `@mantine/core`, so webpack’s
  tree-shaking removed the “unused” stylesheet import) — this made
  [`SpotlightActionsGroup()`](https://coppertank.github.io/shiny.mantine/reference/SpotlightRoot.md)’s
  `label` never actually render.
