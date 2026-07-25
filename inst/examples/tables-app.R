# Demo categoria "Tables" (https://ui.mantine.dev/category/tables/): table
# con progress, table con header fisso, table con selezione, table con
# ricerca e ordinamento. Le ultime due usano il nuovo DataTable() (stato
# client-side); le prime due sono composizione di Table()/TableScrollContainer().
#
# shiny::runApp(system.file("examples/tables-app.R", package = "shiny.mantine"))

library(shiny)
library(shiny.mantine)

books <- list(
  list(title = "Il nome della rosa", positive = 82, negative = 18),
  list(title = "Se questo e' un uomo", positive = 95, negative = 5),
  list(title = "Il barone rampante", positive = 74, negative = 26)
)

employees <- list(
  list(name = "Marco Neri", email = "marco@example.com", company = "Acme Srl"),
  list(
    name = "Giulia Verdi",
    email = "giulia@example.com",
    company = "Beta SpA"
  ),
  list(
    name = "Paolo Gialli",
    email = "paolo@example.com",
    company = "Gamma Srl"
  ),
  list(name = "Sara Blu", email = "sara@example.com", company = "Delta SpA")
)

ui <- fluidPage(
  MantineProvider(
    Container(
      size = "lg",
      py = "xl",

      Title("Table with progress", order = 3, mb = "sm"),
      Table(
        TableThead(TableTr(TableTh("Titolo"), TableTh("Recensioni positive"))),
        TableTbody(
          lapply(books, function(b) {
            TableTr(
              TableTd(b$title),
              TableTd(
                Group(
                  gap = "xs",
                  Text(paste0(b$positive, "%"), size = "sm", w = 40),
                  Box(w = 200, Progress(value = b$positive, color = "teal"))
                )
              )
            )
          })
        )
      ),

      Divider(my = "xl"),

      Title("Table with sticky header", order = 3, mb = "sm"),
      TableScrollContainer(
        minWidth = 400,
        h = 200,
        Table(
          stickyHeader = TRUE,
          stickyHeaderOffset = 0,
          TableThead(TableTr(
            TableTh("Nome"),
            TableTh("Email"),
            TableTh("Azienda")
          )),
          TableTbody(
            lapply(rep(employees, 3), function(e) {
              TableTr(TableTd(e$name), TableTd(e$email), TableTd(e$company))
            })
          )
        )
      ),

      Divider(my = "xl"),

      Title("Table with selection", order = 3, mb = "sm"),
      DataTable(
        inputId = "table_selection",
        data = lapply(seq_along(employees), function(i) {
          c(list(value = i), employees[[i]])
        }),
        columns = list(
          list(key = "name", label = "Nome"),
          list(key = "email", label = "Email"),
          list(key = "company", label = "Azienda")
        ),
        selectable = TRUE
      ),

      Divider(my = "xl"),

      Title("Table with search and sort", order = 3, mb = "sm"),
      DataTable(
        inputId = "table_search_sort",
        data = lapply(seq_along(employees), function(i) {
          c(list(value = i), employees[[i]])
        }),
        columns = list(
          list(key = "name", label = "Nome"),
          list(key = "email", label = "Email"),
          list(key = "company", label = "Azienda")
        ),
        searchable = TRUE,
        sortable = TRUE
      )
    )
  ),
  tags$div(style = "padding: 0 24px 24px;", textOutput("selection_summary"))
)

server <- function(input, output, session) {
  output$selection_summary <- renderText({
    n <- length(input$table_selection$selected %||% list())
    paste(n, "righe selezionate")
  })
}

shinyApp(ui, server)
