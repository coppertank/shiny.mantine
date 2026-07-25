# Demo categoria "Drag'n'Drop" (https://ui.mantine.dev/category/dnd/): lista
# riordinabile, lista riordinabile con maniglia, tabella riordinabile. Usa
# SortableList()/SortableTable() (basati su @hello-pangea/dnd).
#
# shiny::runApp(system.file("examples/dnd-app.R", package = "shiny.mantine"))

library(shiny)
library(shiny.mantine)

elements <- list(
  list(value = "H", label = "Hydrogen"),
  list(value = "He", label = "Helium"),
  list(value = "Li", label = "Lithium"),
  list(value = "Be", label = "Beryllium")
)

element_rows <- list(
  list(value = "H", cells = list("1", "H", "Hydrogen", "1.008")),
  list(value = "He", cells = list("2", "He", "Helium", "4.0026")),
  list(value = "Li", cells = list("3", "Li", "Lithium", "6.94")),
  list(value = "Be", cells = list("4", "Be", "Beryllium", "9.0122"))
)

ui <- fluidPage(
  MantineProvider(
    Container(
      size = "sm",
      py = "xl",

      Title("Drag'n'drop list", order = 3, mb = "sm"),
      Text(
        "Trascina un'intera riga per riordinarla.",
        size = "sm",
        c = "dimmed",
        mb = "sm"
      ),
      SortableList(inputId = "dnd_list", items = elements),

      Divider(my = "xl"),

      Title("Drag'n'drop list with handle", order = 3, mb = "sm"),
      Text(
        "Il trascinamento parte solo dall'icona a manopola.",
        size = "sm",
        c = "dimmed",
        mb = "sm"
      ),
      SortableList(
        inputId = "dnd_list_handle",
        items = elements,
        withHandle = TRUE
      ),

      Divider(my = "xl"),

      Title("Drag'n'drop table", order = 3, mb = "sm"),
      SortableTable(
        inputId = "dnd_table",
        columns = c("Numero", "Simbolo", "Nome", "Massa"),
        items = element_rows
      )
    )
  ),
  tags$div(style = "padding: 0 24px 24px;", verbatimTextOutput("dnd_state"))
)

server <- function(input, output, session) {
  output$dnd_state <- renderPrint({
    list(
      lista = input$dnd_list,
      lista_handle = input$dnd_list_handle,
      tabella = input$dnd_table
    )
  })
}

shinyApp(ui, server)
