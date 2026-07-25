test_that("MantineProvider() forwards fixShinyFontScale = TRUE by default", {
  # The actual scale compensation (measuring the real root font-size and
  # setting theme.scale) happens client-side, in JS, at mount time — see
  # ShinyMantineProvider() in js/src/index.js — because whether the page
  # even loads Shiny's Bootstrap 3 CSS (which sets html to a 10px root)
  # depends on the app's own choice of UI function (fluidPage() vs a plain
  # tagList()), something R has no way to know ahead of time. R's only job
  # is to forward the flag (and leave `theme` completely untouched).
  provider <- MantineProvider(Text("hi"))
  root <- attr(provider, "mantine_root", exact = TRUE)
  expect_equal(root$props$fixShinyFontScale, list(type = "raw", value = TRUE))
  expect_equal(root$props$theme, list(type = "raw", value = NULL))
})

test_that("MantineProvider() passes theme through completely unmodified", {
  provider <- MantineProvider(Text("hi"), theme = list(scale = 1, primaryColor = "red"))
  root <- attr(provider, "mantine_root", exact = TRUE)
  expect_equal(root$props$theme$value$scale, list(type = "raw", value = 1))
  expect_equal(root$props$theme$value$primaryColor, list(type = "raw", value = "red"))
})

test_that("MantineProvider(fixShinyFontScale = FALSE) forwards the flag as FALSE", {
  provider <- MantineProvider(Text("hi"), fixShinyFontScale = FALSE)
  root <- attr(provider, "mantine_root", exact = TRUE)
  expect_equal(root$props$fixShinyFontScale, list(type = "raw", value = FALSE))
})
