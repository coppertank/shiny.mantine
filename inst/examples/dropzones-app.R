# Demo categoria "Dropzones" (https://ui.mantine.dev/category/dropzones/):
# dropzone con bottone di selezione file. Usa Dropzone() (basato su
# @mantine/dropzone). Nota: riporta a Shiny solo i METADATI dei file
# (nome/dimensione/tipo), non il contenuto — abbina un normale
# shiny::fileInput() se ti serve caricare davvero i file (vedi commento
# sotto).
#
# shiny::runApp(system.file("examples/dropzones-app.R", package = "shiny.mantine"))

library(shiny)
library(shiny.mantine)

ui <- fluidPage(
  MantineProvider(
    Container(
      size = "sm",
      py = "xl",
      Title("Dropzone with button", order = 3, mb = "sm"),
      Dropzone(
        inputId = "files_dropped",
        accept = c("application/pdf"),
        maxSize = 30 * 1024^2,
        DropzoneAccept(ThemeIcon(
          IconUpload(size = 32),
          variant = "light",
          color = "blue",
          size = 60,
          radius = "xl"
        )),
        DropzoneReject(ThemeIcon(
          IconX(size = 32),
          variant = "light",
          color = "red",
          size = 60,
          radius = "xl"
        )),
        DropzoneIdle(ThemeIcon(
          IconUpload(size = 32),
          variant = "light",
          color = "gray",
          size = 60,
          radius = "xl"
        )),
        Stack(
          align = "center",
          gap = "xs",
          mt = "sm",
          Text(
            "Trascina qui i file per caricarli, o clicca per selezionarli",
            size = "lg",
            ta = "center"
          ),
          Text(
            "Accettiamo solo file .pdf sotto i 30mb",
            size = "sm",
            c = "dimmed",
            ta = "center"
          )
        )
      )
    )
  ),
  tags$div(style = "padding: 0 24px 24px;", verbatimTextOutput("files_info"))
)

server <- function(input, output, session) {
  output$files_info <- renderPrint({
    req(input$files_dropped)
    input$files_dropped$files
  })

  observeEvent(input$files_dropped, {
    showNotification(paste(input$files_dropped$count, "file ricevuti"))
  })
}

shinyApp(ui, server)
