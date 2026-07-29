# Showcase of what's new in Mantine 9.5 (see NEWS.md): Timeline's
# `opposite`/`alternate` content, the Cascader component, the chart
# `withBrush` range selector, Heatmap's `monthLabelsPosition`, schedule
# view intervals larger than one hour (`intervalMinutes`), and the
# `withNativeLevelSelect` date picker header.
#
# Run after installing the package:
#   shiny::runApp(system.file("examples/mantine-9-5-app.R", package = "shiny.mantine"))

library(shiny)
library(shiny.mantine)

# --- Small layout helper (local to this demo, not exported by the package) ---

section <- function(title, description, ...) {
  Stack(
    gap = "xs",
    mb = "xl",
    Title(title, order = 3),
    Text(description, c = "dimmed", size = "sm", mb = "sm"),
    Paper(withBorder = TRUE, radius = "md", p = "lg", ...)
  )
}

# --- Data for the demos below -------------------------------------------

set.seed(42)
months <- seq(as.Date("2026-01-01"), as.Date("2026-12-01"), by = "month")
revenue <- data.frame(
  month = format(months, "%b"),
  revenue = round(cumsum(rnorm(12, mean = 8, sd = 4)) + 60, 1)
)

heatmap_data <- setNames(
  as.list(sample(1:10, 90, replace = TRUE)),
  format(seq(as.Date("2026-01-01"), by = "day", length.out = 90), "%Y-%m-%d")
)

schedule_resources <- data.frame(
  id = c("tokyo", "paris", "ny"),
  label = c(
    "Meeting room: Tokyo",
    "Meeting room: Paris",
    "Meeting room: New York"
  )
)
schedule_events <- data.frame(
  id = 1:4,
  title = c("Team standup", "Client call", "Design review", "All-hands"),
  start = c(
    "2026-07-27 08:00:00",
    "2026-07-27 12:00:00",
    "2026-07-27 16:00:00",
    "2026-07-27 20:00:00"
  ),
  end = c(
    "2026-07-27 09:00:00",
    "2026-07-27 14:00:00",
    "2026-07-27 18:00:00",
    "2026-07-27 21:30:00"
  ),
  color = c("blue", "green", "grape", "orange"),
  resourceId = c("tokyo", "paris", "tokyo", "ny")
)

# --- UI -------------------------------------------------------------------

ui <- fluidPage(
  MantineProvider(
    Container(
      size = "lg",
      py = "xl",
      Title("What's new in Mantine 9.5", order = 1, mb = "xl"),

      section(
        "Timeline: opposite and alternate content",
        "`opposite` renders content on the other side of the line (switching Timeline to a centered layout); `alternate` flips which side an individual item's content/opposite land on.",
        Timeline(
          active = 2,
          bulletSize = 24,
          lineWidth = 2,
          TimelineItem(
            title = "Order placed",
            opposite = Text("10:00", size = "sm", c = "dimmed"),
            Text("The customer placed the order.", size = "sm")
          ),
          TimelineItem(
            title = "Payment confirmed",
            opposite = Text("10:02", size = "sm", c = "dimmed"),
            Text("Payment was processed successfully.", size = "sm"),
            alternate = TRUE
          ),
          TimelineItem(
            title = "Preparing shipment",
            opposite = Text("11:45", size = "sm", c = "dimmed"),
            Text("Items are being packed at the warehouse.", size = "sm")
          ),
          TimelineItem(
            title = "Shipped",
            opposite = Text("Expected", size = "sm", c = "dimmed"),
            Text("Tracking number will be sent by email.", size = "sm"),
            alternate = TRUE
          )
        )
      ),

      section(
        "Cascader",
        "Drill down through nested options column by column — here, picking a location through Continent → Country → City. The selected value is the full path from root to the chosen node.",
        Cascader(
          inputId = "location",
          label = "Location",
          placeholder = "Pick a location",
          clearable = TRUE,
          data = list(
            list(
              value = "asia",
              label = "Asia",
              children = list(
                list(
                  value = "jp",
                  label = "Japan",
                  children = list(
                    list(value = "tokyo", label = "Tokyo"),
                    list(value = "osaka", label = "Osaka")
                  )
                ),
                list(
                  value = "cn",
                  label = "China",
                  children = list(
                    list(value = "shanghai", label = "Shanghai"),
                    list(value = "beijing", label = "Beijing")
                  )
                )
              )
            ),
            list(
              value = "europe",
              label = "Europe",
              children = list(
                list(
                  value = "it",
                  label = "Italy",
                  children = list(
                    list(value = "rome", label = "Rome"),
                    list(value = "milan", label = "Milan")
                  )
                ),
                list(
                  value = "fr",
                  label = "France",
                  children = list(
                    list(value = "paris", label = "Paris")
                  )
                )
              )
            )
          )
        )
      ),

      section(
        "Charts: brush range selector",
        "Set `withBrush = TRUE` on LineChart()/BarChart()/AreaChart()/CompositeChart() to show a range selector under the chart for zooming into a subset of the data. Drag the handles below the chart.",
        LineChart(
          h = 280,
          data = revenue,
          dataKey = "month",
          series = list(list(name = "revenue", color = "blue.6")),
          curveType = "monotone",
          withBrush = TRUE,
          accessibilityLayer = TRUE
        )
      ),

      section(
        "Heatmap: month labels position",
        "`monthLabelsPosition` moves the month labels to the bottom of the grid instead of the default top — handy when the heatmap sits above other content.",
        Group(
          align = "flex-start",
          grow = TRUE,
          Stack(
            gap = 4,
            Text("Default (top)", size = "xs", fw = 600),
            Heatmap(
              data = heatmap_data,
              startDate = "2026-01-01",
              endDate = "2026-03-31",
              withTooltip = TRUE
            )
          ),
          Stack(
            gap = 4,
            Text("monthLabelsPosition = \"bottom\"", size = "xs", fw = 600),
            Heatmap(
              data = heatmap_data,
              startDate = "2026-01-01",
              endDate = "2026-03-31",
              withTooltip = TRUE,
              monthLabelsPosition = "bottom"
            )
          )
        )
      ),

      section(
        "Schedule: intervals larger than one hour",
        "ResourcesDayView()/ResourcesWeekView()'s `intervalMinutes` (default 60) now also accepts whole numbers of hours above 60 (e.g. 240) — each time-slot column then spans several hours instead of subdividing within one, fitting a full day of resources compactly.",
        Box(
          h = 320,
          ResourcesDayView(
            inputId = "resday",
            date = as.Date("2026-07-27"),
            resources = schedule_resources,
            events = schedule_events,
            intervalMinutes = 240,
            withEventsDragAndDrop = TRUE,
            highlightBusinessHours = TRUE
          )
        )
      ),

      section(
        "Date pickers: native level select",
        "`withNativeLevelSelect = TRUE` replaces the calendar header's month/year click-to-navigate buttons with native <select> elements — often faster for jumping far in either direction.",
        Group(
          align = "flex-start",
          grow = TRUE,
          Stack(
            gap = 4,
            Text("Default header", size = "xs", fw = 600),
            DatePicker(inputId = "dp_default")
          ),
          Stack(
            gap = 4,
            Text("withNativeLevelSelect = TRUE", size = "xs", fw = 600),
            DatePicker(inputId = "dp_native", withNativeLevelSelect = TRUE)
          )
        )
      )
    )
  ),
  # Native Shiny bindings (verbatimTextOutput(), ...) can't be nested inside
  # MantineProvider() — its content is inserted via dangerouslySetInnerHTML,
  # which Shiny never rescans for bindings — so this "current values" panel
  # lives outside it instead. See vignette("getting-started").
  tags$div(
    style = "max-width: 960px; margin: 0 auto; padding: 0 24px 24px;",
    tags$h4("Current values"),
    verbatimTextOutput("state")
  )
)

# --- Server -----------------------------------------------------------------

server <- function(input, output, session) {
  output$state <- renderPrint(list(
    location = input$location,
    resday_event_click = input$resday_event_click,
    resday_event_drop = input$resday_event_drop,
    dp_default = input$dp_default,
    dp_native = input$dp_native
  ))
}

shinyApp(ui, server)
