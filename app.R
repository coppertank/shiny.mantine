library(shiny)
library(shiny.mantine)

ui <- fluidPage(
  MantineProvider(
    defaultColorScheme = "light",
    tags$h2("shiny.mantine — demo"),
    TextInput(
      inputId = "username",
      label = "Your name",
      placeholder = "Type here..."
    ),
    tags$div(style = "height: 12px;"),
    Button("Greet", inputId = "greet_btn", variant = "filled", color = "blue")
  ),
  tags$hr(),
  textOutput("greeting"),
  verbatimTextOutput("clicks")
)

server <- function(input, output, session) {

  output$greeting <- renderText({
    req(input$username)
    paste("You typed:", input$username)
  })

  output$clicks <- renderPrint({
    req(input$greet_btn)
    paste("Button clicked", input$greet_btn, "times")
  })

  observeEvent(input$greet_btn, {
    showNotification(paste0("Hello, ", input$username %||% "", "!"))
  })
}

shinyApp(ui, server)
