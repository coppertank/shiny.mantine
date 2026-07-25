# Demo categoria "Grids" (https://ui.mantine.dev/category/grids/):
# Grid with asymmetrical columns, Grid with leading item, Grid with vertical
# items. Pura composizione di Grid()/GridCol()/SimpleGrid() gia' presenti nel
# pacchetto — nessuna nuova primitiva necessaria.
#
# shiny::runApp(system.file("examples/grids-app.R", package = "shiny.mantine"))

library(shiny)
library(shiny.mantine)

box <- function(label, h = 100) {
  Paper(
    withBorder = TRUE,
    p = "md",
    h = h,
    radius = "md",
    Text(label, c = "dimmed", size = "sm")
  )
}

ui <- fluidPage(
  MantineProvider(
    Container(
      size = "lg",
      py = "xl",

      Title("Grid with asymmetrical columns", order = 3, mb = "sm"),
      Grid(
        GridCol(span = 8, box("Colonna larga (span 8/12)", h = 140)),
        GridCol(span = 4, box("Colonna stretta (span 4/12)", h = 140))
      ),

      Divider(my = "xl"),

      Title("Grid with leading item", order = 3, mb = "sm"),
      Grid(
        GridCol(span = 12, box("Elemento principale (span 12/12)", h = 160)),
        GridCol(span = 4, box("span 4/12")),
        GridCol(span = 4, box("span 4/12")),
        GridCol(span = 4, box("span 4/12"))
      ),

      Divider(my = "xl"),

      Title("Grid with vertical items", order = 3, mb = "sm"),
      Text(
        "Ogni colonna impila piu' elementi verticalmente.",
        c = "dimmed",
        mb = "sm",
        size = "sm"
      ),
      SimpleGrid(
        cols = list(base = 1, sm = 3),
        Stack(box("Riga 1", h = 70), box("Riga 2", h = 70)),
        Stack(box("Riga 1", h = 70), box("Riga 2", h = 70)),
        Stack(box("Riga 1", h = 70), box("Riga 2", h = 70))
      )
    )
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)
