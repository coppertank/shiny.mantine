#' @include mantine-element.R
NULL

#' @keywords internal
chartData <- function(data) {
  if (is.data.frame(data)) {
    return(lapply(seq_len(nrow(data)), function(i) {
      as.list(data[i, , drop = FALSE])
    }))
  }
  data
}

#' Mantine LineChart / BarChart / AreaChart (multi-series charts)
#'
#' `data` can be a `data.frame` (one row per point/category, one column per
#' field — converted automatically) or a list of `list()`s with the same
#' structure. `series` indicates which columns to draw: a list of
#' `list(name = "column", color = "blue.6")`.
#'
#' @rdname LineChart
#' @param data Chart data (`data.frame` or list of rows).
#' @param series List of `list(name = ..., color = ...)`, one per series.
#' @param ... Other props (`dataKey`, `curveType`, `withLegend`,
#'   `withTooltip`, ...). See <https://mantine.dev/charts/line-chart/>.
#' @export
#' @examples
#' \dontrun{
#' LineChart(
#'   data = data.frame(month = c("Jan", "Feb", "Mar"), sales = c(120, 150, 90)),
#'   dataKey = "month",
#'   series = list(list(name = "sales", color = "blue.6"))
#' )
#' }
LineChart <- function(data, series, ...) {
  mantineElement("LineChart", data = chartData(data), series = series, ...)
}

#' @rdname LineChart
#' @export
BarChart <- function(data, series, ...) {
  mantineElement("BarChart", data = chartData(data), series = series, ...)
}

#' @rdname LineChart
#' @export
AreaChart <- function(data, series, ...) {
  mantineElement("AreaChart", data = chartData(data), series = series, ...)
}

#' Mantine PieChart / DonutChart (pie/donut charts)
#'
#' `data` is a `data.frame` (or list of rows) with columns `name`, `value`,
#' and optionally `color`.
#'
#' @rdname PieChart
#' @param data Chart data (`data.frame` or list of rows, with
#'   `name`/`value`/`color`).
#' @param ... Other props (`withLabels`, `withTooltip`, `size`, ...). See
#'   <https://mantine.dev/charts/pie-chart/>.
#' @export
#' @examples
#' \dontrun{
#' PieChart(data = data.frame(
#'   name = c("A", "B", "C"),
#'   value = c(40, 35, 25),
#'   color = c("blue.6", "orange.6", "grape.6")
#' ))
#' }
PieChart <- function(data, ...) {
  mantineElement("PieChart", data = chartData(data), ...)
}

#' @rdname PieChart
#' @export
DonutChart <- function(data, ...) {
  mantineElement("DonutChart", data = chartData(data), ...)
}

#' Mantine RadarChart / CompositeChart (multi-series charts)
#'
#' `RadarChart()` plots one or more series across radial axes (`dataKey`
#' picks the column used for axis labels). `CompositeChart()` is like
#' `LineChart()`/`BarChart()`/`AreaChart()` but each series in `series` can
#' set its own `type` (`"line"`/`"bar"`/`"area"`), combining them in one
#' chart. Both accept `data` as a `data.frame` or list of rows, same as
#' [LineChart()].
#'
#' @rdname RadarChart
#' @param data Chart data (`data.frame` or list of rows).
#' @param series List of `list(name = ..., color = ...)` (`CompositeChart()`
#'   series can also set `type = "line"/"bar"/"area"`).
#' @param dataKey Column used for radar axis labels.
#' @param ... Other props. See <https://mantine.dev/charts/radar-chart/> /
#'   <https://mantine.dev/charts/composite-chart/>.
#' @export
RadarChart <- function(data, series, dataKey, ...) {
  mantineElement(
    "RadarChart",
    data = chartData(data),
    series = series,
    dataKey = dataKey,
    ...
  )
}

#' @rdname RadarChart
#' @export
CompositeChart <- function(data, series, ...) {
  mantineElement("CompositeChart", data = chartData(data), series = series, ...)
}

#' Mantine RadialBarChart / BubbleChart
#'
#' `RadialBarChart()` plots one value per row as a radial bar (`dataKey`
#' picks the value column; per-row `color` in `data` controls each bar's
#' color). `BubbleChart()` plots points sized by a third dimension —
#' `dataKey` is `list(x = "col", y = "col", z = "col")` (x/y position, z ->
#' bubble size). Both accept `data` as a `data.frame` or list of rows.
#'
#' @rdname RadialBarChart
#' @param data Chart data (`data.frame` or list of rows).
#' @param dataKey For `RadialBarChart()`, the value column name. For
#'   `BubbleChart()`, `list(x = ..., y = ..., z = ...)`.
#' @param ... Other props. See <https://mantine.dev/charts/radial-bar-chart/>
#'   / <https://mantine.dev/charts/bubble-chart/>.
#' @export
RadialBarChart <- function(data, dataKey, ...) {
  mantineElement(
    "RadialBarChart",
    data = chartData(data),
    dataKey = dataKey,
    ...
  )
}

#' @rdname RadialBarChart
#' @export
BubbleChart <- function(data, dataKey, ...) {
  mantineElement("BubbleChart", data = chartData(data), dataKey = dataKey, ...)
}

#' Mantine FunnelChart (funnel/conversion chart)
#'
#' `data` is a `data.frame` (or list of rows) with columns `name`, `value`,
#' and optionally `color` — same shape as [PieChart()].
#' @param data Chart data (`data.frame` or list of rows).
#' @param ... Other props. See <https://mantine.dev/charts/funnel-chart/>.
#' @export
FunnelChart <- function(data, ...) {
  mantineElement("FunnelChart", data = chartData(data), ...)
}

#' Mantine Sparkline (small inline chart)
#'
#' @param data A plain numeric vector (or list with `NA`/`NULL` gaps), one
#'   point per value — not a `data.frame` (there are no separate fields to
#'   pick a column from).
#' @param ... Other props (`color`, `trendColors`, `curveType`, `w`, `h`,
#'   ...). See <https://mantine.dev/charts/sparkline/>.
#' @export
#' @examples
#' \dontrun{
#' Sparkline(data = c(10, 25, 15, 30, 22, 40), color = "blue", h = 40)
#' }
Sparkline <- function(data, ...) {
  mantineElement("Sparkline", data = data, ...)
}

#' Mantine ScatterChart (x/y scatter plot)
#'
#' Unlike the other charts, `data` is a list of *series*, each with its own
#' nested points — pass it exactly in Mantine's shape (no automatic
#' `data.frame` conversion, since there is no single flat table to convert).
#'
#' @param data List of `list(name = ..., color = ..., data = list(list(x =
#'   ..., y = ...), ...))`, one entry per series.
#' @param dataKey `list(x = "col", y = "col")` — the field names read from
#'   each point.
#' @param ... Other props. See <https://mantine.dev/charts/scatter-chart/>.
#' @export
#' @examples
#' \dontrun{
#' ScatterChart(
#'   data = list(list(
#'     name = "Group A", color = "blue.5",
#'     data = list(list(age = 20, bmi = 22), list(age = 30, bmi = 25))
#'   )),
#'   dataKey = list(x = "age", y = "bmi")
#' )
#' }
ScatterChart <- function(data, dataKey, ...) {
  mantineElement("ScatterChart", data = data, dataKey = dataKey, ...)
}

#' Mantine Treemap (hierarchical rectangles chart)
#'
#' `data` is a nested list matching Mantine's shape directly (no automatic
#' conversion): a list of `list(name = ..., value = ..., color = ..., ...)`,
#' optionally with a nested `children` list per node for hierarchy.
#' @param data Nested list of chart nodes. See
#'   <https://mantine.dev/charts/treemap/>.
#' @param ... Other props (`h`, `withTooltip`, `colorAlpha`, ...).
#' @export
Treemap <- function(data, ...) {
  mantineElement("Treemap", data = data, ...)
}

#' Mantine Heatmap (calendar-style heatmap)
#'
#' @param data A *named* list, not a `data.frame`: names are
#'   `"YYYY-MM-DD"` date strings, values are the numeric intensity for that
#'   day (e.g. `list("2024-01-01" = 5, "2024-01-02" = 12)`).
#' @param startDate,endDate Range shown, as `"YYYY-MM-DD"` strings or R
#'   `Date`/`POSIXct` values (converted automatically).
#' @param ... Other props (`colors`, `withTooltip`, `withWeekdayLabels`,
#'   ...). See <https://mantine.dev/charts/heatmap/>.
#' @export
#' @examples
#' \dontrun{
#' Heatmap(
#'   data = list("2024-01-01" = 5, "2024-01-05" = 12, "2024-01-12" = 8),
#'   startDate = "2024-01-01", endDate = "2024-03-31"
#' )
#' }
Heatmap <- function(data, startDate = NULL, endDate = NULL, ...) {
  mantineElement(
    "Heatmap",
    data = data,
    startDate = toDateString(startDate),
    endDate = toDateString(endDate),
    ...
  )
}

#' Mantine SankeyChart (flow diagram)
#'
#' `data` is a named list matching Mantine's shape directly: `list(nodes =
#' list(list(name = ...), ...), links = list(list(source = <index>, target =
#' <index>, value = ...), ...))` — `source`/`target` are 0-based indices
#' into `nodes`.
#' @param data `list(nodes = ..., links = ...)`. See
#'   <https://mantine.dev/charts/sankey-chart/>.
#' @param ... Other props.
#' @export
#' @examples
#' \dontrun{
#' SankeyChart(data = list(
#'   nodes = list(list(name = "A"), list(name = "B"), list(name = "C")),
#'   links = list(list(source = 0, target = 1, value = 10), list(source = 1, target = 2, value = 5))
#' ))
#' }
SankeyChart <- function(data, ...) {
  mantineElement("SankeyChart", data = data, ...)
}

#' Mantine BarsList (list of horizontal bars with names and values)
#'
#' @param data A `data.frame` (or list of rows) with `name` and `value`
#'   columns.
#' @param ... Other props (`barsLabel`, `valueLabel`, `barGap`,
#'   `minBarSize`, `barHeight`, ...). See
#'   <https://mantine.dev/charts/bars-list/>.
#' @export
#' @examples
#' \dontrun{
#' BarsList(data = data.frame(
#'   name = c("React", "Vue", "Angular"),
#'   value = c(950000, 320000, 580000)
#' ))
#' }
BarsList <- function(data, ...) {
  mantineElement("BarsList", data = chartData(data), ...)
}

#' Mantine SunburstChart (hierarchical concentric-rings chart)
#'
#' `data` is a nested list matching Mantine's shape directly (no automatic
#' `data.frame` conversion, like [Treemap()]/[SankeyChart()]): a list of
#' `list(name=, value=, color=, children=...)`. Leaf nodes need `value`;
#' parent nodes nest further options under `children` instead. Every node
#' needs `name`/`color`; children inherit their parent's color if omitted.
#' @param data Nested list of chart nodes. See
#'   <https://mantine.dev/charts/sunburst-chart/>.
#' @param ... Other props (`size`, `withLabels`, `withTooltip`, `gap`,
#'   `strokeColor`, ...).
#' @export
#' @examples
#' \dontrun{
#' SunburstChart(data = list(
#'   list(name = "Frontend", color = "blue.6", children = list(
#'     list(name = "React", value = 400),
#'     list(name = "Vue", value = 200)
#'   )),
#'   list(name = "Backend", value = 500, color = "red.6")
#' ))
#' }
SunburstChart <- function(data, ...) {
  mantineElement("SunburstChart", data = data, ...)
}

#' Mantine BulletChart (compact KPI chart: value vs. target vs. ranges)
#'
#' @param value The actual value to display.
#' @param ranges Qualitative performance ranges: a `data.frame` (or list of
#'   rows) with `value` (the range's upper bound) and `color` columns, and
#'   optionally `label` — ordered smallest to largest (Mantine renders
#'   them back-to-front, largest first).
#' @param ... Other props (`target`, `label`, `orientation`, `size`,
#'   `barSize`, `barColor`, `targetColor`, `withTooltip`, `h` — required
#'   for `orientation = "vertical"`, ...). See
#'   <https://mantine.dev/charts/bullet-chart/>.
#' @export
#' @examples
#' \dontrun{
#' BulletChart(
#'   value = 260000,
#'   target = 275000,
#'   label = "Revenue",
#'   ranges = data.frame(
#'     value = c(150000, 225000, 300000),
#'     color = c("red.8", "yellow.8", "teal.8"),
#'     label = c("Poor", "Average", "Good")
#'   )
#' )
#' }
BulletChart <- function(value, ranges, ...) {
  mantineElement("BulletChart", value = value, ranges = chartData(ranges), ...)
}
