test_that("Stepper() serializes mantineId/inputId/active correctly", {
  el <- Stepper(mantineId = "wizard", inputId = "wizard_click", active = 1)
  expect_equal(el$name, "Stepper")
  expect_equal(el$props$mantineId, list(type = "raw", value = "wizard"))
  expect_equal(el$props$inputId, list(type = "raw", value = "wizard_click"))
  expect_equal(el$props$active, list(type = "raw", value = 1))
})

test_that("StepperStep()/StepperCompleted() map to the Stepper.* JS names", {
  expect_equal(StepperStep(label = "Step 1")$name, "Stepper.Step")
  expect_equal(StepperCompleted("Done")$name, "Stepper.Completed")
})

test_that("Tree() serializes inputId/data as-is", {
  data <- list(list(value = "a", label = "A"))
  el <- Tree(inputId = "tree_click", data = data)
  expect_equal(el$name, "Tree")
  expect_equal(el$props$inputId, list(type = "raw", value = "tree_click"))
  expect_equal(el$props$data$type, "array")
})

test_that("TreeSelect() and its update function behave like a value input", {
  el <- TreeSelect(inputId = "ts", data = list(), value = "a")
  expect_equal(el$name, "TreeSelect")
  expect_equal(el$props$value, list(type = "raw", value = "a"))

  session <- mock_session()
  updateMantineTreeSelect(session, "ts", value = "b")
  msg <- session$.messages$log[[1]]
  expect_equal(msg$type, "shinyMantineUpdateInput")
  expect_equal(msg$message$value, "b")
})

test_that("Collapse() sends `opened`, not `in`, as the wire prop name", {
  # Regression test: Collapse's real Mantine prop is `expanded` (renamed to
  # `opened` on the JS side) — the R wrapper must expose the same `opened`
  # name consistently, both at creation and via updateMantineProps(), or
  # updateMantineProps(session, mantineId, opened = TRUE) silently does
  # nothing (this exact bug was caught in browser testing).
  el <- Collapse(mantineId = "details", opened = FALSE, "content")
  expect_equal(el$props$opened, list(type = "raw", value = FALSE))
  expect_null(el$props[["in"]])
})

test_that("CheckboxGroup()/CheckboxGroupItem() default to an empty array, matching MultiSelect's convention", {
  el <- CheckboxGroup(inputId = "cg")
  expect_equal(el$props$value, list(type = "array", value = list()))

  item <- CheckboxGroupItem(value = "apple", label = "Apple")
  expect_equal(item$name, "CheckboxGroupItem")
  expect_equal(item$props$value, list(type = "raw", value = "apple"))
})

test_that("SwitchGroup()/SwitchGroupItem() mirror CheckboxGroup()/CheckboxGroupItem()", {
  el <- SwitchGroup(inputId = "sg")
  expect_equal(el$props$value, list(type = "array", value = list()))

  item <- SwitchGroupItem(value = "dark", label = "Dark mode")
  expect_equal(item$name, "SwitchGroupItem")
})

test_that("CheckboxCard()/RadioCard() are raw displayComponent()s", {
  expect_equal(CheckboxCard(value = "a")$name, "CheckboxCard")
  expect_equal(RadioCard(value = "a")$name, "RadioCard")
})

test_that("FileButton() serializes its metadata-only contract", {
  el <- FileButton(inputId = "fb", label = "Upload", accept = "image/png", multiple = TRUE)
  expect_equal(el$name, "FileButton")
  expect_equal(el$props$accept, list(type = "raw", value = "image/png"))
  expect_equal(el$props$multiple, list(type = "raw", value = TRUE))
})

test_that("MaskInput() and its update function serialize correctly", {
  el <- MaskInput(inputId = "phone", mask = "+1 (999) 999-9999")
  expect_equal(el$name, "MaskInput")
  expect_equal(el$props$mask, list(type = "raw", value = "+1 (999) 999-9999"))

  session <- mock_session()
  updateMantineMaskInput(session, "phone", value = "+1 (212) 555-9999")
  msg <- session$.messages$log[[1]]
  expect_equal(msg$type, "shinyMantineUpdateInput")
  expect_equal(msg$message$value, "+1 (212) 555-9999")
})

test_that("DirectionProvider() defaults to ltr", {
  expect_equal(DirectionProvider()$props$dir, list(type = "raw", value = "ltr"))
  expect_equal(DirectionProvider(dir = "rtl")$props$dir, list(type = "raw", value = "rtl"))
})

test_that("CardSection()/ActionIconGroup() map to the expected compound JS names", {
  expect_equal(CardSection()$name, "Card.Section")
  expect_equal(ActionIconGroup()$name, "ActionIcon.Group")
})

test_that("Menu extension helpers map to the expected compound JS names", {
  expect_equal(MenuSub()$name, "Menu.Sub")
  expect_equal(MenuSubTarget()$name, "Menu.Sub.Target")
  expect_equal(MenuSubDropdown()$name, "Menu.Sub.Dropdown")
  expect_equal(menuSubItem("id", "value", "Label")$name, "Menu.Sub.Item")
  expect_equal(MenuCheckboxGroup()$name, "Menu.CheckboxGroup")
  expect_equal(MenuCheckboxItem("id")$name, "Menu.CheckboxItem")
  expect_equal(MenuRadioGroup("id")$name, "Menu.RadioGroup")
  expect_equal(MenuRadioItem("value")$name, "Menu.RadioItem")
  expect_equal(MenuSearch()$name, "Menu.Search")
  expect_equal(MenuContextMenu()$name, "Menu.ContextMenu")
})

test_that("Menubar family maps to the expected compound JS names", {
  expect_equal(Menubar()$name, "Menubar")
  expect_equal(MenubarMenu()$name, "Menubar.Menu")
  expect_equal(MenubarTarget()$name, "Menubar.Target")
  expect_equal(MenubarDropdown()$name, "Menubar.Dropdown")
})

test_that("Splitter()/SplitterPanel() map to the expected compound JS names", {
  expect_equal(Splitter()$name, "Splitter")
  expect_equal(SplitterPanel()$name, "Splitter.Panel")
})
