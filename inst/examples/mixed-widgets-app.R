# Demo di alcuni componenti eterogenei: Splitter (pannelli ridimensionabili),
# AngleSlider (dial circolare), PasswordInput, PinInput, DatePicker (il
# widget calendario sempre visibile), Stepper (wizard multi-step) e un
# bottone per alternare il tema chiaro/scuro dell'intera app.
#
# shiny::runApp(system.file("examples/mixed-widgets-app.R", package = "shiny.mantine"))

library(shiny)
library(shiny.mantine)

box <- function(title, ...) {
  Stack(
    Title(title, order = 4),
    Paper(withBorder = TRUE, radius = "md", p = "lg", ...)
  )
}

ui <- fluidPage(
  MantineProvider(
    Stack(
      style = list(padding = "24px"),
      gap = "lg",

      Group(
        justify = "space-between",
        Title("Mixed widgets", order = 2),
        ColorSchemeToggle(inputId = "color_scheme")
      ),

      SimpleGrid(
        cols = list(base = 1, md = 2),
        spacing = "lg",

        box(
          "Splitter",
          Splitter(
            style = list(height = "200px"),
            SplitterPanel(
              defaultSize = 40,
              minSize = 20,
              Center(h = "100%", Text("Left pane"))
            ),
            SplitterPanel(
              Center(h = "100%", Text("Right pane"))
            )
          )
        ),

        box(
          "AngleSlider",
          Center(
            Stack(
              align = "center",
              AngleSlider(inputId = "angle", value = 45),
              Text(
                textOutput("angle_value", inline = TRUE),
                size = "sm",
                c = "dimmed"
              )
            )
          )
        ),

        box(
          "PasswordInput",
          PasswordInput(
            inputId = "password",
            label = "Password",
            description = "Almeno 8 caratteri",
            placeholder = "La tua password"
          )
        ),

        box(
          "PinInput",
          Stack(
            align = "center",
            PinInput(inputId = "pin", length = 6, type = "number"),
            Text(
              textOutput("pin_value", inline = TRUE),
              size = "sm",
              c = "dimmed"
            )
          )
        ),

        box(
          "DatePicker (calendario)",
          Center(DatePicker(inputId = "calendar_date", value = Sys.Date()))
        ),

        box(
          "Stepper",
          Stack(
            Stepper(
              mantineId = "wizard",
              inputId = "wizard_step_click",
              active = 0,
              StepperStep(
                label = "Account",
                description = "Crea il tuo account"
              ),
              StepperStep(label = "Verifica", description = "Verifica l'email"),
              StepperStep(label = "Fine", description = "Configura il profilo"),
              StepperCompleted(Text(
                "Tutti gli step completati!",
                ta = "center",
                mt = "md"
              ))
            ),
            Group(
              justify = "center",
              Button("Indietro", inputId = "wizard_back", variant = "default"),
              Button("Avanti", inputId = "wizard_next")
            )
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  output$angle_value <- renderText(paste0(round(input$angle %||% 45), "°"))
  output$pin_value <- renderText(input$pin %||% "")

  wizard_active <- reactiveVal(0)

  observeEvent(input$wizard_next, {
    wizard_active(min(wizard_active() + 1, 3))
    updateMantineProps(session, "wizard", active = wizard_active())
  })

  observeEvent(input$wizard_back, {
    wizard_active(max(wizard_active() - 1, 0))
    updateMantineProps(session, "wizard", active = wizard_active())
  })

  observeEvent(input$wizard_step_click, {
    wizard_active(input$wizard_step_click)
    updateMantineProps(session, "wizard", active = wizard_active())
  })

  observeEvent(input$color_scheme, {
    message("Tema cambiato in: ", input$color_scheme)
  })
}

shinyApp(ui, server)
