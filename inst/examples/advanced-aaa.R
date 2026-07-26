library(shiny)
library(shiny.mantine)


ui <- fluidPage(
  MantineProvider(),
)

server <- function(input, output, session) {}

shinyApp(ui, server)
