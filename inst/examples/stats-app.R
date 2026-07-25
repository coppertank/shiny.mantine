# Demo categoria "Stats" (https://ui.mantine.dev/category/stats/): progress
# card, progress card con colore, card con progresso e timeline, stats con
# controlli, stats grid, stats grid con icone diff, grouped stats, stats con
# ring progress, stats con segmenti. Composizione di Paper/Progress/
# RingProgress/Text/Title/Group/SimpleGrid gia' presenti nel pacchetto.
#
# shiny::runApp(system.file("examples/stats-app.R", package = "shiny.mantine"))

library(shiny)
library(shiny.mantine)

statCard <- function(
  label,
  value,
  diff,
  color = if (diff >= 0) "teal" else "red"
) {
  Paper(
    withBorder = TRUE,
    p = "lg",
    radius = "md",
    Text(label, size = "xs", c = "dimmed", tt = "uppercase", fw = 700),
    Group(
      align = "flex-end",
      gap = "xs",
      mt = 4,
      Text(value, fw = 700, size = "xl"),
      Group(
        gap = 4,
        if (diff >= 0) {
          IconArrowUpRight(size = 14, color = "teal")
        } else {
          IconArrowDownRight(size = 14, color = "red")
        },
        Text(
          paste0(if (diff >= 0) "+" else "", diff, "%"),
          c = color,
          size = "sm",
          fw = 500
        )
      )
    ),
    Text("rispetto al mese precedente", size = "xs", c = "dimmed", mt = 4)
  )
}

ui <- fluidPage(
  MantineProvider(
    Container(
      size = "lg",
      py = "xl",

      Title("Progress card", order = 3, mb = "sm"),
      Paper(
        withBorder = TRUE,
        p = "lg",
        radius = "md",
        w = 320,
        Group(
          justify = "space-between",
          Text("Obiettivo mensile", size = "sm", fw = 500),
          Text("$5,431 / $10,000", size = "sm", c = "dimmed")
        ),
        Progress(value = 54, mt = "sm")
      ),

      Divider(my = "xl"),

      Title("Progress card with color", order = 3, mb = "sm"),
      Paper(
        withBorder = TRUE,
        p = "lg",
        radius = "md",
        w = 320,
        Group(
          justify = "space-between",
          Text("Storage", size = "sm", fw = 500),
          Text("78%", size = "sm", c = "dimmed")
        ),
        Progress(value = 78, color = "orange", mt = "sm")
      ),

      Divider(my = "xl"),

      Title("Card with progress", order = 3, mb = "sm"),
      Paper(
        withBorder = TRUE,
        p = "lg",
        radius = "md",
        w = 320,
        Text("Project tasks", fw = 500),
        Text(
          "62% completato — 4 giorni rimanenti",
          size = "sm",
          c = "dimmed",
          mb = "xs"
        ),
        Progress(value = 62)
      ),

      Divider(my = "xl"),

      Title("Stats with controls", order = 3, mb = "sm"),
      Stack(
        w = 400,
        Stack(
          gap = 4,
          Group(
            justify = "space-between",
            Text("Running", size = "sm"),
            Text("83%", size = "sm", c = "dimmed")
          ),
          Progress(value = 83, color = "blue")
        ),
        Stack(
          gap = 4,
          Group(
            justify = "space-between",
            Text("Swimming", size = "sm"),
            Text("45%", size = "sm", c = "dimmed")
          ),
          Progress(value = 45, color = "cyan")
        ),
        Stack(
          gap = 4,
          Group(
            justify = "space-between",
            Text("Bike", size = "sm"),
            Text("67%", size = "sm", c = "dimmed")
          ),
          Progress(value = 67, color = "grape")
        )
      ),

      Divider(my = "xl"),

      Title("Stats grid", order = 3, mb = "sm"),
      SimpleGrid(
        cols = list(base = 1, sm = 3),
        Paper(
          withBorder = TRUE,
          p = "lg",
          radius = "md",
          Text("Revenue", size = "xs", c = "dimmed", tt = "uppercase"),
          Text("$25,430", fw = 700, size = "xl")
        ),
        Paper(
          withBorder = TRUE,
          p = "lg",
          radius = "md",
          Text("Orders", size = "xs", c = "dimmed", tt = "uppercase"),
          Text("1,893", fw = 700, size = "xl")
        ),
        Paper(
          withBorder = TRUE,
          p = "lg",
          radius = "md",
          Text("Refunds", size = "xs", c = "dimmed", tt = "uppercase"),
          Text("102", fw = 700, size = "xl")
        )
      ),

      Divider(my = "xl"),

      Title("Stats grid with diff icons", order = 3, mb = "sm"),
      SimpleGrid(
        cols = list(base = 1, sm = 3),
        statCard("Revenue", "$25,430", 12),
        statCard("Orders", "1,893", 4),
        statCard("Refunds", "102", -2)
      ),

      Divider(my = "xl"),

      Title("Grouped stats", order = 3, mb = "sm"),
      Paper(
        withBorder = TRUE,
        p = "lg",
        radius = "md",
        Group(
          grow = TRUE,
          Stack(
            gap = 0,
            Text("456", fw = 700, size = "xl"),
            Text("Utenti registrati", size = "sm", c = "dimmed"),
            Text("+11% questo mese", size = "xs", c = "teal")
          ),
          Stack(
            gap = 0,
            Text("2,145", fw = 700, size = "xl"),
            Text("Sessioni", size = "sm", c = "dimmed"),
            Text("+6% questo mese", size = "xs", c = "teal")
          ),
          Stack(
            gap = 0,
            Text("34%", fw = 700, size = "xl"),
            Text("Tasso di rimbalzo", size = "sm", c = "dimmed"),
            Text("-3% questo mese", size = "xs", c = "red")
          )
        )
      ),

      Divider(my = "xl"),

      Title("Stats with ring progress", order = 3, mb = "sm"),
      Group(
        Paper(
          withBorder = TRUE,
          p = "lg",
          radius = "md",
          Group(
            RingProgress(
              size = 80,
              thickness = 8,
              sections = list(list(value = 65, color = "blue")),
              label = Text("65%", ta = "center", size = "xs", fw = 700)
            ),
            Stack(
              gap = 0,
              Text("Completamento", size = "sm", c = "dimmed"),
              Text("65%", fw = 700, size = "lg")
            )
          )
        ),
        Paper(
          withBorder = TRUE,
          p = "lg",
          radius = "md",
          Group(
            RingProgress(
              size = 80,
              thickness = 8,
              sections = list(list(value = 42, color = "grape")),
              label = Text("42%", ta = "center", size = "xs", fw = 700)
            ),
            Stack(
              gap = 0,
              Text("Obiettivo vendite", size = "sm", c = "dimmed"),
              Text("42%", fw = 700, size = "lg")
            )
          )
        )
      ),

      Divider(my = "xl"),

      Title("Stats with segments", order = 3, mb = "sm"),
      Paper(
        withBorder = TRUE,
        p = "lg",
        radius = "md",
        w = 400,
        Text("Traffico per dispositivo", fw = 500, mb = "sm"),
        RingProgress(
          size = 150,
          sections = list(
            list(value = 40, color = "blue", tooltip = "Mobile 40%"),
            list(value = 35, color = "cyan", tooltip = "Desktop 35%"),
            list(value = 25, color = "grape", tooltip = "Tablet 25%")
          ),
          label = Text("100%", ta = "center", size = "sm", fw = 700)
        ),
        Group(
          mt = "sm",
          Group(
            gap = 4,
            Box(
              w = 10,
              h = 10,
              style = list(
                borderRadius = 2,
                backgroundColor = "var(--mantine-color-blue-6)"
              )
            ),
            Text("Mobile 40%", size = "xs")
          ),
          Group(
            gap = 4,
            Box(
              w = 10,
              h = 10,
              style = list(
                borderRadius = 2,
                backgroundColor = "var(--mantine-color-cyan-6)"
              )
            ),
            Text("Desktop 35%", size = "xs")
          ),
          Group(
            gap = 4,
            Box(
              w = 10,
              h = 10,
              style = list(
                borderRadius = 2,
                backgroundColor = "var(--mantine-color-grape-6)"
              )
            ),
            Text("Tablet 25%", size = "xs")
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)
