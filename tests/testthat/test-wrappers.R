test_that("MultiSelect/TagsInput default to an empty array, not NULL", {
  # Regression test: Mantine calls .map() on `value` internally for these
  # array-typed inputs, so a `NULL` default serializes to JSON `null` and
  # crashes the whole React tree with "Cannot read properties of null
  # (reading 'map')". The fix is defaulting to list() (JSON `[]`).
  ms <- MultiSelect("ms1")
  expect_equal(ms$props$value, list(type = "array", value = list()))

  ti <- TagsInput("ti1")
  expect_equal(ti$props$value, list(type = "array", value = list()))
})

test_that("ensureArray() always coerces to a genuine (unnamed) list", {
  expect_equal(ensureArray(NULL), list())
  expect_equal(ensureArray("a"), list("a"))
  expect_equal(ensureArray(c("a", "b")), list("a", "b"))
  expect_equal(ensureArray(list("a")), list("a"))
})

test_that("MultiSelect/TagsInput/CheckboxGroup/SwitchGroup keep a single-item value as an array", {
  # Regression test: jsonlite::toJSON(..., auto_unbox = TRUE) - used both
  # by renderMantineRoot() for the initial element tree and by Shiny's own
  # default custom-message serializer for updateMantineXxx() - collapses a
  # length-1 atomic vector to a bare JSON scalar instead of a 1-element
  # array. Each of these components calls .map() on `value` unconditionally
  # on the JS side, so `value = c("onlyone")` used to crash exactly like
  # the NULL case above ("value.map is not a function").
  expect_equal(MultiSelect("ms1", value = c("onlyone"))$props$value, list(type = "array", value = list(list(type = "raw", value = "onlyone"))))
  expect_equal(TagsInput("ti1", value = c("onlyone"))$props$value, list(type = "array", value = list(list(type = "raw", value = "onlyone"))))
  expect_equal(CheckboxGroup("cg1", value = c("onlyone"))$props$value, list(type = "array", value = list(list(type = "raw", value = "onlyone"))))
  expect_equal(SwitchGroup("sg1", value = c("onlyone"))$props$value, list(type = "array", value = list(list(type = "raw", value = "onlyone"))))
})

test_that("updateMantineMultiSelect()/updateMantineTagsInput()/updateMantineCheckboxGroup()/updateMantineSwitchGroup() keep a single-item value as an array", {
  session <- mock_session()
  updateMantineMultiSelect(session, "ms1", value = c("onlyone"))
  expect_equal(session$.messages$log[[1]]$message$value, list("onlyone"))

  session <- mock_session()
  updateMantineTagsInput(session, "ti1", value = c("onlyone"))
  expect_equal(session$.messages$log[[1]]$message$value, list("onlyone"))

  session <- mock_session()
  updateMantineCheckboxGroup(session, "cg1", value = c("onlyone"))
  expect_equal(session$.messages$log[[1]]$message$value, list("onlyone"))

  session <- mock_session()
  updateMantineSwitchGroup(session, "sg1", value = c("onlyone"))
  expect_equal(session$.messages$log[[1]]$message$value, list("onlyone"))
})

test_that("toDateString() passes through strings and formats Date objects", {
  expect_null(toDateString(NULL))
  expect_equal(toDateString("2026-07-24"), "2026-07-24")
  expect_equal(toDateString(as.Date("2026-07-24")), "2026-07-24")
})

test_that("DateInput() serializes Date values through toDateString()", {
  el <- DateInput("d1", value = as.Date("2026-01-15"))
  expect_equal(el$props$value, list(type = "raw", value = "2026-01-15"))
})

test_that("chartData() converts a data.frame into one list per row", {
  df <- data.frame(mese = c("Gen", "Feb"), vendite = c(10, 20))
  out <- chartData(df)

  expect_length(out, 2)
  expect_equal(out[[1]], list(mese = "Gen", vendite = 10))
  expect_equal(out[[2]], list(mese = "Feb", vendite = 20))
})

test_that("chartData() passes through a list of rows unchanged", {
  rows <- list(list(name = "A", value = 1), list(name = "B", value = 2))
  expect_identical(chartData(rows), rows)
})

test_that("LineChart()/PieChart() apply chartData() to the data argument", {
  df <- data.frame(name = "A", value = 1)
  el <- PieChart(data = df)
  expect_equal(el$props$data$type, "array")
  expect_equal(el$props$data$value[[1]]$type, "object")
})

test_that("updateMantineProps() sends {id, props} via shinyMantineUpdateProps", {
  session <- mock_session()
  updateMantineProps(session, "my_modal", opened = TRUE, title = "Hi")

  expect_length(session$.messages$log, 1)
  msg <- session$.messages$log[[1]]
  expect_equal(msg$type, "shinyMantineUpdateProps")
  expect_equal(msg$message$id, "my_modal")
  expect_equal(msg$message$props, list(opened = TRUE, title = "Hi"))
})

test_that("updateMantineTextInput() sends {inputId, value} via shinyMantineUpdateInput", {
  session <- mock_session()
  updateMantineTextInput(session, "txt1", value = "new value")

  msg <- session$.messages$log[[1]]
  expect_equal(msg$type, "shinyMantineUpdateInput")
  expect_equal(msg$message$inputId, "txt1")
  expect_equal(msg$message$value, "new value")
})

test_that("showMantineNotification() sends the expected payload", {
  session <- mock_session()
  showMantineNotification(session, title = "Done", message = "It worked", color = "green")

  msg <- session$.messages$log[[1]]
  expect_equal(msg$type, "shinyMantineNotification")
  expect_equal(msg$message$title, "Done")
  expect_equal(msg$message$color, "green")
})

test_that("nprogress helpers send {action, value} via shinyMantineProgress", {
  session <- mock_session()
  startMantineProgress(session)
  setMantineProgress(70, session)
  completeMantineProgress(session)

  log <- session$.messages$log
  expect_equal(vapply(log, function(m) m$message$action, character(1)), c("start", "set", "complete"))
  expect_equal(log[[2]]$message$value, 70)
})

test_that("updateMantineRichTextEditor() sends the HTML content as inputId/value", {
  session <- mock_session()
  updateMantineRichTextEditor(session, "bio", content = "<p>hi</p>")

  msg <- session$.messages$log[[1]]
  expect_equal(msg$type, "shinyMantineUpdateInput")
  expect_equal(msg$message$inputId, "bio")
  expect_equal(msg$message$value, "<p>hi</p>")
})
