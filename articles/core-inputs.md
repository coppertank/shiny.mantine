# Core: Inputs

``` r

library(shiny)
library(shiny.mantine)
```

An R rewrite of the [“Inputs”
category](https://mantine.dev/core/text-input/) on mantine.dev/core.
Every stateful component here keeps `input[[inputId]]` in sync
automatically (typed value, dragged slider position, …) and has a
matching `update*()` function to push a new value from the server — see
[`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md)
for updating any *other* prop instead.

## TextInput

<https://mantine.dev/core/text-input/> — a single-line text field.

``` r

TextInput(inputId = "name", label = "Your name", placeholder = "Ada Lovelace", description = "As it appears on your profile")
```

## Textarea

<https://mantine.dev/core/textarea/> — multi-line text field;
`autosize = TRUE` + `minRows`/`maxRows` grows with content.

``` r

Textarea(inputId = "bio", label = "Bio", autosize = TRUE, minRows = 2, maxRows = 6)
```

## PasswordInput

<https://mantine.dev/core/password-input/> — a text field with a
show/hide visibility toggle built in.

``` r

PasswordInput(inputId = "password", label = "Password", description = "At least 8 characters")
```

## NumberInput

<https://mantine.dev/core/number-input/> — a numeric field with
increment/decrement controls; `min`/`max`/`step`/`decimalScale` all work
as documented on mantine.dev.

``` r

NumberInput(inputId = "qty", label = "Quantity", value = 1, min = 0, max = 100, step = 1)
```

## PinInput

<https://mantine.dev/core/pin-input/> — a one-time-password-style set of
single-character boxes; `input[[inputId]]` is the concatenated string.

``` r

PinInput(inputId = "otp", length = 6, type = "number")
```

## JsonInput

<https://mantine.dev/core/json-input/> — a textarea with JSON validation
and optional formatting on blur.

``` r

JsonInput(
  inputId = "config", label = "Config", formatOnBlur = TRUE, autosize = TRUE, minRows = 4,
  validationError = "Invalid JSON"
)
```

## Fieldset

<https://mantine.dev/core/fieldset/> — groups related inputs under a
`legend`, with an optional `variant = "filled"` background.

``` r

Fieldset(
  legend = "Personal information",
  TextInput(inputId = "first_name", label = "First name"),
  TextInput(inputId = "last_name", label = "Last name")
)
```

## Checkbox

<https://mantine.dev/core/checkbox/> — a boolean toggle;
`input[[inputId]]` is `TRUE`/`FALSE`. For an array-valued group of
checkboxes, see
[`CheckboxGroup()`](https://coppertank.github.io/shiny.mantine/reference/CheckboxGroup.md)
in
[`vignette("extras")`](https://coppertank.github.io/shiny.mantine/articles/extras.md),
or the
[`CheckboxCard()`](https://coppertank.github.io/shiny.mantine/reference/CheckboxCard.md)/[`CheckboxIndicator()`](https://coppertank.github.io/shiny.mantine/reference/RadioIndicator.md)
variants there too.

``` r

Checkbox(inputId = "terms", label = "I accept the terms of service")
```

## Radio

<https://mantine.dev/core/radio/> — a single radio option; nest several
inside
[`RadioGroup()`](https://coppertank.github.io/shiny.mantine/reference/RadioGroup.md)
(stateful, reports the selected `value`) to build an actual choice:

``` r

RadioGroup(
  inputId = "plan", label = "Choose a plan",
  Radio(value = "free", label = "Free"),
  Radio(value = "pro", label = "Pro")
)
```

## Switch

<https://mantine.dev/core/switch/> — a boolean toggle styled as an
on/off switch instead of a checkbox; same `TRUE`/`FALSE` semantics.

``` r

Switch(inputId = "notifications", label = "Enable notifications", value = TRUE)
```

## Chip

<https://mantine.dev/core/chip/> — a pill-shaped selectable tag; nest
several inside
[`ChipGroup()`](https://coppertank.github.io/shiny.mantine/reference/ChipGroup.md)
(add `multiple = TRUE` for multi-select).

``` r

ChipGroup(
  inputId = "tags", value = "r",
  Chip(value = "r", "R"), Chip(value = "python", "Python"), Chip(value = "js", "JavaScript")
)
```

## Slider

<https://mantine.dev/core/slider/> — a draggable single-value slider.
[`RangeSlider()`](https://coppertank.github.io/shiny.mantine/reference/RangeSlider.md)
is the two-handle variant, syncing a length-2 vector.

``` r

Slider(inputId = "volume", value = 50, min = 0, max = 100, label = function(v) paste0(v, "%"))
RangeSlider(inputId = "price_range", value = c(20, 80), min = 0, max = 200)
```

## AngleSlider

<https://mantine.dev/core/angle-slider/> — a circular dial for picking
an angle/direction, 0-359 degrees.

``` r

AngleSlider(inputId = "gradient_angle", value = 45)
```

## SegmentedControl

<https://mantine.dev/core/segmented-control/> — a set of mutually
exclusive options styled as connected segments, an alternative to
[`RadioGroup()`](https://coppertank.github.io/shiny.mantine/reference/RadioGroup.md)
for a small, always-visible set of choices.

``` r

SegmentedControl(inputId = "view", data = c("List", "Grid", "Table"), value = "List")
```

## ColorInput

<https://mantine.dev/core/color-input/> — a text field with a live color
swatch and picker dropdown;
[`ColorPicker()`](https://coppertank.github.io/shiny.mantine/reference/ColorPicker.md)
is the picker alone, without the text field, for embedding directly in a
layout.
[`HueSlider()`](https://coppertank.github.io/shiny.mantine/reference/HueSlider.md)/
[`AlphaSlider()`](https://coppertank.github.io/shiny.mantine/reference/AlphaSlider.md)
are
[`ColorPicker()`](https://coppertank.github.io/shiny.mantine/reference/ColorPicker.md)’s
individual channel sliders, usable standalone if you’re composing your
own custom color picker.

``` r

ColorInput(inputId = "brand_color", label = "Brand color", value = "#228be6", format = "hex")
ColorPicker(inputId = "swatch_picker", value = "#228be6", format = "hex")
```

## Rating

<https://mantine.dev/core/rating/> — a star (or custom-icon) rating
input.

``` r

Rating(inputId = "stars", value = 3, count = 5)
```

## FileInput

<https://mantine.dev/core/file-input/> — a styled file picker. Because
file *content* can’t be serialized over the same channel as other input
values, only metadata (`name`/`size`/`type`) is reported to Shiny as
`input[[inputId]]$files`; pair it with a real
[`shiny::fileInput()`](https://rdrr.io/pkg/shiny/man/fileInput.html)
alongside it if you need the actual upload.

``` r

FileInput(inputId = "avatar", label = "Upload avatar", accept = "image/*")
```

## NativeSelect

<https://mantine.dev/core/native-select/> — a `<select>` element styled
to match the rest of the inputs, lighter-weight than
[`Select()`](https://coppertank.github.io/shiny.mantine/reference/Select.md)’s
combobox-driven dropdown (see
[`vignette("core-combobox")`](https://coppertank.github.io/shiny.mantine/articles/core-combobox.md)).

``` r

NativeSelect(inputId = "country", label = "Country", data = c("Italy", "France", "Germany"))
```

## Input, InputBase, and the Input family

<https://mantine.dev/core/input/> — the styled box (border, focus ring,
left/right sections) every input above uses internally, with **no**
value/onChange management of its own; use it (or
[`InputBase()`](https://coppertank.github.io/shiny.mantine/reference/InputBase.md))
for visual composition when the exact input types above don’t fit — a
read-only display, a custom trigger, etc.
[`InputWrapper()`](https://coppertank.github.io/shiny.mantine/reference/InputWrapper.md)/
[`InputLabel()`](https://coppertank.github.io/shiny.mantine/reference/InputLabel.md)/[`InputDescription()`](https://coppertank.github.io/shiny.mantine/reference/InputDescription.md)/[`InputError()`](https://coppertank.github.io/shiny.mantine/reference/InputError.md)/[`InputSuccess()`](https://coppertank.github.io/shiny.mantine/reference/InputSuccess.md)/
[`InputPlaceholder()`](https://coppertank.github.io/shiny.mantine/reference/InputPlaceholder.md)
give arbitrary custom content the same label/description/error/success
chrome.
[`InputClearButton()`](https://coppertank.github.io/shiny.mantine/reference/InputClearButton.md)
is the “x” clear button
[`Select()`](https://coppertank.github.io/shiny.mantine/reference/Select.md)/date
pickers render when clearable.
[`PillsInput()`](https://coppertank.github.io/shiny.mantine/reference/PillsInput.md)/[`PillsInputField()`](https://coppertank.github.io/shiny.mantine/reference/PillsInput.md)
are the multi-value input box
[`MultiSelect()`](https://coppertank.github.io/shiny.mantine/reference/MultiSelect.md)/[`TagsInput()`](https://coppertank.github.io/shiny.mantine/reference/TagsInput.md)
build on (see
[`vignette("core-combobox")`](https://coppertank.github.io/shiny.mantine/articles/core-combobox.md)).

``` r

InputWrapper(
  label = "Custom field", description = "Composed from Input() + a left icon",
  Input(placeholder = "Search...", leftSection = IconSearch(size = 16))
)
```

## MaskInput (not on mantine.dev — a `shiny.mantine` addition)

A masked text field (e.g. phone numbers, dates typed as digits), built
on top of `@mantine/hooks`’ `useMask()` since Mantine core has no
built-in masked input.

``` r

MaskInput(inputId = "phone", label = "Phone", mask = "+1 (999) 999-9999")
```

## Where to go next

- [`vignette("core-combobox")`](https://coppertank.github.io/shiny.mantine/articles/core-combobox.md)
  —
  [`Select()`](https://coppertank.github.io/shiny.mantine/reference/Select.md),
  [`MultiSelect()`](https://coppertank.github.io/shiny.mantine/reference/MultiSelect.md),
  [`Autocomplete()`](https://coppertank.github.io/shiny.mantine/reference/Autocomplete.md),
  [`TagsInput()`](https://coppertank.github.io/shiny.mantine/reference/TagsInput.md),
  [`TreeSelect()`](https://coppertank.github.io/shiny.mantine/reference/TreeSelect.md),
  [`Pill()`](https://coppertank.github.io/shiny.mantine/reference/Pill.md).
- [`vignette("extras")`](https://coppertank.github.io/shiny.mantine/articles/extras.md)
  — group inputs
  ([`CheckboxGroup()`](https://coppertank.github.io/shiny.mantine/reference/CheckboxGroup.md),
  [`RadioCard()`](https://coppertank.github.io/shiny.mantine/reference/CheckboxCard.md),
  …) and other `shiny.mantine`-only additions.
