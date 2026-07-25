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
