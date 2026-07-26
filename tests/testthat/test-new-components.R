test_that("Combobox() serializes with inputId/opened and forwards children", {
  el <- Combobox(
    inputId = "fruit",
    ComboboxTarget(Button("Pick", inputId = "pick_btn")),
    ComboboxDropdown(ComboboxOptions(ComboboxOption(value = "apple", "Apple")))
  )

  expect_equal(el$name, "Combobox")
  expect_equal(el$props$inputId, list(type = "raw", value = "fruit"))
  expect_equal(el$props$opened, list(type = "raw", value = FALSE))
})

test_that("Combobox compound parts serialize with the expected JS names", {
  expect_equal(ComboboxTarget()$name, "Combobox.Target")
  expect_equal(ComboboxEventsTarget()$name, "Combobox.EventsTarget")
  expect_equal(ComboboxDropdownTarget()$name, "Combobox.DropdownTarget")
  expect_equal(ComboboxDropdown()$name, "Combobox.Dropdown")
  expect_equal(ComboboxOptions()$name, "Combobox.Options")
  expect_equal(ComboboxEmpty()$name, "Combobox.Empty")
  expect_equal(ComboboxFooter()$name, "Combobox.Footer")
  expect_equal(ComboboxHeader()$name, "Combobox.Header")
  expect_equal(ComboboxGroup()$name, "Combobox.Group")
  expect_equal(ComboboxChevron()$name, "Combobox.Chevron")
  expect_equal(ComboboxClearButton()$name, "Combobox.ClearButton")
  expect_equal(ComboboxHiddenInput()$name, "Combobox.HiddenInput")
})

test_that("ComboboxOption() forwards its value prop", {
  el <- ComboboxOption(value = "banana", "Banana")
  expect_equal(el$name, "Combobox.Option")
  expect_equal(el$props$value, list(type = "raw", value = "banana"))
})

test_that("ComboboxSearch() serializes inputId/value like a text input", {
  el <- ComboboxSearch(inputId = "search1", value = "ap")
  expect_equal(el$name, "Combobox.Search")
  expect_equal(el$props$inputId, list(type = "raw", value = "search1"))
  expect_equal(el$props$value, list(type = "raw", value = "ap"))
})

test_that("updateMantineComboboxSearch()/updateMantineComboboxPopover() send inputId/value", {
  session <- mock_session()
  updateMantineComboboxSearch(session, "search1", value = "banana")
  msg <- session$.messages$log[[1]]
  expect_equal(msg$type, "shinyMantineUpdateInput")
  expect_equal(msg$message$inputId, "search1")
  expect_equal(msg$message$value, "banana")

  session2 <- mock_session()
  updateMantineComboboxPopover(session2, "framework", value = "React")
  msg2 <- session2$.messages$log[[1]]
  expect_equal(msg2$type, "shinyMantineUpdateInput")
  expect_equal(msg2$message$inputId, "framework")
  expect_equal(msg2$message$value, "React")
})

test_that("ComboboxPopover() serializes inputId/data/value and its Target child", {
  el <- ComboboxPopover(
    inputId = "framework", data = c("React", "Vue"), value = "React",
    ComboboxPopoverTarget(Button("Pick", inputId = "pick_btn"))
  )
  expect_equal(el$name, "ComboboxPopover")
  expect_equal(el$props$inputId, list(type = "raw", value = "framework"))
  expect_equal(el$props$value, list(type = "raw", value = "React"))
  expect_equal(ComboboxPopoverTarget()$name, "ComboboxPopover.Target")
})

test_that("OverflowList() forwards children and overflow/layout props", {
  el <- OverflowList(Badge("A"), Badge("B"), overflowLabel = "+{n} more", maxRows = 2)
  expect_equal(el$name, "OverflowList")
  expect_equal(el$props$overflowLabel, list(type = "raw", value = "+{n} more"))
  expect_equal(el$props$maxRows, list(type = "raw", value = 2))
  expect_equal(el$props$children$type, "array")
  expect_length(el$props$children$value, 2)
})

test_that("TableOfContents() defaults scrollSpySelector and forwards other props", {
  el <- TableOfContents()
  expect_equal(el$name, "TableOfContents")
  expect_equal(el$props$scrollSpySelector, list(type = "raw", value = "h1, h2, h3, h4, h5, h6"))

  el2 <- TableOfContents(scrollSpySelector = "#content h2, #content h3", size = "sm")
  expect_equal(el2$props$scrollSpySelector, list(type = "raw", value = "#content h2, #content h3"))
  expect_equal(el2$props$size, list(type = "raw", value = "sm"))
})

test_that("MonthPicker()/YearPicker() apply toDateString() to value", {
  m <- MonthPicker("m1", value = as.Date("2026-03-01"))
  expect_equal(m$name, "MonthPicker")
  expect_equal(m$props$value, list(type = "raw", value = "2026-03-01"))

  y <- YearPicker("y1", value = "2026-01-01")
  expect_equal(y$name, "YearPicker")
  expect_equal(y$props$value, list(type = "raw", value = "2026-01-01"))
})

test_that("updateMantineMonthPicker()/updateMantineYearPicker() send inputId/value", {
  session <- mock_session()
  updateMantineMonthPicker(session, "m1", value = as.Date("2026-05-01"))
  msg <- session$.messages$log[[1]]
  expect_equal(msg$message$inputId, "m1")
  expect_equal(msg$message$value, "2026-05-01")

  session2 <- mock_session()
  updateMantineYearPicker(session2, "y1", value = as.Date("2026-01-01"))
  msg2 <- session2$.messages$log[[1]]
  expect_equal(msg2$message$inputId, "y1")
  expect_equal(msg2$message$value, "2026-01-01")
})

test_that("toTimeString() passes through strings and formats POSIXct values", {
  expect_null(toTimeString(NULL))
  expect_equal(toTimeString("18:45:34"), "18:45:34")
  expect_equal(
    toTimeString(as.POSIXct("2021-02-01 18:45:34", tz = "UTC")),
    "18:45:34"
  )
})

test_that("TimeValue() formats value via toTimeString()", {
  el <- TimeValue(value = "18:45:34", format = "12h")
  expect_equal(el$name, "TimeValue")
  expect_equal(el$props$value, list(type = "raw", value = "18:45:34"))
  expect_equal(el$props$format, list(type = "raw", value = "12h"))
})

test_that("BarsList() applies chartData() to the data argument", {
  df <- data.frame(name = c("React", "Vue"), value = c(950000, 320000))
  el <- BarsList(data = df)
  expect_equal(el$name, "BarsList")
  expect_equal(el$props$data$type, "array")
  expect_equal(el$props$data$value[[1]], list(type = "object", value = list(
    name = list(type = "raw", value = "React"),
    value = list(type = "raw", value = 950000)
  )))
})

test_that("RichTextEditor() forwards a controls layout", {
  el <- RichTextEditor(
    "bio",
    controls = list(c("bold", "italic"), c("bulletList", "orderedList"))
  )
  expect_equal(el$name, "RichTextEditor")
  expect_equal(el$props$controls$type, "array")
  expect_length(el$props$controls$value, 2)
  expect_equal(el$props$controls$value[[1]]$type, "array")
  expect_equal(
    vapply(el$props$controls$value[[1]]$value, function(x) x$value, character(1)),
    c("bold", "italic")
  )
})

test_that("RichTextEditor() keeps a single-control group as an array, not a scalar", {
  # Regression test: a length-1 character vector (e.g. c("bold")) would
  # otherwise auto-unbox to a bare JSON string via jsonlite::toJSON(...,
  # auto_unbox = TRUE), crashing the JS side's group.map() ("group.map is
  # not a function").
  el <- RichTextEditor("bio", controls = list(c("bold")))
  expect_equal(el$props$controls$type, "array")
  expect_length(el$props$controls$value, 1)
  expect_equal(el$props$controls$value[[1]]$type, "array")
  expect_equal(el$props$controls$value[[1]]$value[[1]], list(type = "raw", value = "bold"))
})
