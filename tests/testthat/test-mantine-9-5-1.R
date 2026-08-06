test_that("FloatingWindow() serializes inputId, other props, and children", {
  el <- FloatingWindow(
    inputId = "win1",
    dimensions = list(initialWidth = 220, minWidth = 150),
    style = list(border = "1px solid #ddd"),
    Text("content"),
    FloatingWindowResizeHandle()
  )
  expect_equal(el$name, "FloatingWindow")
  expect_equal(el$props$inputId, list(type = "raw", value = "win1"))
  expect_equal(el$props$dimensions$type, "object")
  expect_equal(el$props$children$type, "array")
  expect_length(el$props$children$value, 2)
})

test_that("FloatingWindow() works with inputId omitted (NULL)", {
  el <- FloatingWindow(Text("content"))
  expect_equal(el$name, "FloatingWindow")
  expect_equal(el$props$inputId, list(type = "raw", value = NULL))
})

test_that("FloatingWindowResizeHandle() still serializes with the expected JS name", {
  expect_equal(FloatingWindowResizeHandle()$name, "FloatingWindow.ResizeHandle")
})
