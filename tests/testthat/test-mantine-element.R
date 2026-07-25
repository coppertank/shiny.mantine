test_that("mantineElement() produces the {type, name, props} tree the JS side expects", {
  el <- Button("Click me", inputId = "btn1", color = "blue")

  expect_s3_class(el, "mantine_element")
  expect_equal(el$type, "element")
  expect_equal(el$name, "Button")
  expect_equal(el$props$inputId, list(type = "raw", value = "btn1"))
  expect_equal(el$props$color, list(type = "raw", value = "blue"))
})

test_that("toMantineData() unwraps nested mantine_element children", {
  inner <- Text("hello")
  outer <- Card(inner)

  props <- outer$props
  # unnamed ... children land under "children" per shiny.react::asProps()
  child <- props$children
  expect_equal(child$type, "element")
  expect_equal(child$name, "Text")
})

test_that("toMantineData() serializes NULL as {type: 'raw', value: NULL}", {
  expect_equal(toMantineData(NULL), list(type = "raw", value = NULL))
})

test_that("toMantineData() serializes unnamed lists as {type: 'array'}", {
  out <- toMantineData(list(1, 2, 3))
  expect_equal(out$type, "array")
  expect_length(out$value, 3)
  expect_equal(out$value[[1]], list(type = "raw", value = 1))
})

test_that("toMantineData() serializes named lists as {type: 'object'}", {
  out <- toMantineData(list(a = 1, b = "x"))
  expect_equal(out$type, "object")
  expect_equal(out$value$a, list(type = "raw", value = 1))
  expect_equal(out$value$b, list(type = "raw", value = "x"))
})

test_that("toMantineData() converts shiny.tag/htmltools output to {type: 'html'}", {
  tag <- htmltools::div("hi")
  out <- toMantineData(tag)
  expect_equal(out$type, "html")
  expect_true(grepl("<div", out$value))
})

test_that("toMantineData() recovers the raw element through the mantine_root attribute", {
  # Regression test for the MantineProvider()-nested-inside-another-call bug:
  # renderMantineRoot() attaches the pre-serialization element as an
  # attribute so it can be recovered instead of being flattened to an inert
  # HTML string (whose embedded <script> mount call would never execute).
  raw_el <- Stack(Text("nested"))
  fragment <- renderMantineRoot(raw_el)

  recovered <- toMantineData(fragment)
  expect_equal(recovered$type, "element")
  expect_equal(recovered$name, "Stack")
})

test_that("displayComponent() builds a plain named element with no required args", {
  comp <- displayComponent("Whatever")
  el <- comp(size = "lg")
  expect_s3_class(el, "mantine_element")
  expect_equal(el$name, "Whatever")
  expect_equal(el$props$size, list(type = "raw", value = "lg"))
})
