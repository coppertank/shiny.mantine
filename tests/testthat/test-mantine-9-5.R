test_that("Cascader() serializes inputId/data/value", {
  data <- list(
    list(value = "asia", label = "Asia", children = list(
      list(value = "jp", label = "Japan")
    ))
  )
  el <- Cascader("loc1", data = data, value = c("asia", "jp"))
  expect_equal(el$name, "Cascader")
  expect_equal(el$props$inputId, list(type = "raw", value = "loc1"))
  expect_equal(el$props$value$type, "array")
  expect_equal(
    vapply(el$props$value$value, function(x) x$value, character(1)),
    c("asia", "jp")
  )
})

test_that("Cascader() keeps a single-level path as an array, not a scalar", {
  el <- Cascader("loc1", data = list(), value = c("asia"))
  expect_equal(el$props$value, list(type = "array", value = list(list(type = "raw", value = "asia"))))
})

test_that("Cascader() leaves value as NULL when nothing is selected", {
  el <- Cascader("loc1", data = list())
  expect_equal(el$props$value, list(type = "raw", value = NULL))
})

test_that("updateMantineCascader() sends inputId/value, keeping a single-level path as an array", {
  session <- mock_session()
  updateMantineCascader(session, "loc1", value = c("asia"))
  msg <- session$.messages$log[[1]]
  expect_equal(msg$type, "shinyMantineUpdateInput")
  expect_equal(msg$message$inputId, "loc1")
  expect_equal(msg$message$value, list("asia"))

  session2 <- mock_session()
  updateMantineCascader(session2, "loc1", value = NULL)
  expect_null(session2$.messages$log[[1]]$message$value)
})

test_that("FloatingWindowResizeHandle() serializes with the expected JS name", {
  expect_equal(FloatingWindowResizeHandle()$name, "FloatingWindow.ResizeHandle")
})

test_that("SunburstChart() forwards its nested data as-is", {
  data <- list(
    list(name = "Frontend", color = "blue.6", children = list(
      list(name = "React", value = 400)
    )),
    list(name = "Backend", value = 500, color = "red.6")
  )
  el <- SunburstChart(data = data)
  expect_equal(el$name, "SunburstChart")
  expect_equal(el$props$data$type, "array")
  expect_length(el$props$data$value, 2)
})

test_that("BulletChart() applies chartData() to ranges and forwards value/target", {
  ranges <- data.frame(
    value = c(150000, 225000, 300000),
    color = c("red.8", "yellow.8", "teal.8")
  )
  el <- BulletChart(value = 260000, ranges = ranges, target = 275000)
  expect_equal(el$name, "BulletChart")
  expect_equal(el$props$value, list(type = "raw", value = 260000))
  expect_equal(el$props$target, list(type = "raw", value = 275000))
  expect_equal(el$props$ranges$type, "array")
  expect_equal(el$props$ranges$value[[1]]$type, "object")
})

test_that("DropzoneFullScreen() serializes inputId/active and other props", {
  el <- DropzoneFullScreen("files1", mantineId = "dz1", active = TRUE, Text("Drop here"))
  expect_equal(el$name, "Dropzone.FullScreen")
  expect_equal(el$props$inputId, list(type = "raw", value = "files1"))
  expect_equal(el$props$active, list(type = "raw", value = TRUE))
  expect_equal(el$props$mantineId, list(type = "raw", value = "dz1"))
})
