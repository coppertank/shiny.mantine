test_that("scheduleEvents() converts data.frame rows and formats start/end", {
  df <- data.frame(
    id = 1:2, title = c("A", "B"),
    start = as.POSIXct(c("2026-07-27 09:00:00", "2026-07-27 11:00:00"), tz = "UTC"),
    end = as.POSIXct(c("2026-07-27 10:00:00", "2026-07-27 12:00:00"), tz = "UTC")
  )
  out <- scheduleEvents(df)
  expect_length(out, 2)
  expect_equal(out[[1]]$start, "2026-07-27 09:00:00")
  expect_equal(out[[1]]$end, "2026-07-27 10:00:00")
  expect_equal(out[[1]]$title, "A")
})

test_that("scheduleEvents() passes through a list of rows, formatting start/end", {
  rows <- list(list(id = 1, title = "A", start = as.Date("2026-07-27"), end = as.Date("2026-07-27")))
  out <- scheduleEvents(rows)
  expect_equal(out[[1]]$start, "2026-07-27 00:00:00")
})

test_that("DayView()/WeekView()/MonthView()/YearView() serialize with the expected JS names", {
  expect_equal(DayView("d1")$name, "DayView")
  expect_equal(WeekView("w1")$name, "WeekView")
  expect_equal(MonthView("m1")$name, "MonthView")
  expect_equal(YearView("y1")$name, "YearView")
})

test_that("DayView() serializes inputId/date/events", {
  el <- DayView(
    "d1", date = as.Date("2026-07-27"),
    events = data.frame(id = 1, title = "Meeting", start = "2026-07-27 09:00:00", end = "2026-07-27 10:00:00"),
    startTime = "08:00:00"
  )
  expect_equal(el$props$inputId, list(type = "raw", value = "d1"))
  expect_equal(el$props$date, list(type = "raw", value = "2026-07-27"))
  expect_equal(el$props$startTime, list(type = "raw", value = "08:00:00"))
  expect_equal(el$props$events$type, "array")
  expect_equal(el$props$events$value[[1]]$type, "object")
})

test_that("ResourcesDayView()/ResourcesWeekView()/ResourcesMonthView() serialize resources and intervalMinutes", {
  resources <- data.frame(id = c("tokyo", "paris"), label = c("Tokyo", "Paris"))
  el <- ResourcesDayView("r1", resources = resources, intervalMinutes = 240)
  expect_equal(el$name, "ResourcesDayView")
  expect_equal(el$props$intervalMinutes, list(type = "raw", value = 240))
  expect_equal(el$props$resources$type, "array")
  expect_length(el$props$resources$value, 2)
  expect_equal(el$props$resources$value[[1]]$value$id, list(type = "raw", value = "tokyo"))

  expect_equal(ResourcesWeekView("r2", resources = resources)$name, "ResourcesWeekView")
  expect_equal(ResourcesMonthView("r3", resources = resources)$name, "ResourcesMonthView")
})

test_that("AgendaView() serializes rangeStart/rangeEnd and events", {
  el <- AgendaView("a1", rangeStart = as.Date("2026-07-27"), rangeEnd = as.Date("2026-08-03"))
  expect_equal(el$name, "AgendaView")
  expect_equal(el$props$rangeStart, list(type = "raw", value = "2026-07-27"))
  expect_equal(el$props$rangeEnd, list(type = "raw", value = "2026-08-03"))
})

test_that("MobileMonthView() serializes date and selectedDate independently", {
  el <- MobileMonthView("mob1", date = as.Date("2026-07-01"), selectedDate = as.Date("2026-07-15"))
  expect_equal(el$name, "MobileMonthView")
  expect_equal(el$props$date, list(type = "raw", value = "2026-07-01"))
  expect_equal(el$props$selectedDate, list(type = "raw", value = "2026-07-15"))
})

test_that("Schedule() serializes date/view/events", {
  el <- Schedule("sched1", date = as.Date("2026-07-27"), view = "week")
  expect_equal(el$name, "Schedule")
  expect_equal(el$props$view, list(type = "raw", value = "week"))
  expect_equal(el$props$date, list(type = "raw", value = "2026-07-27"))
})
