# Demo "Modals": le tre modalita' per usare i modal in shiny.mantine -
# Modal() dichiarato in UI + updateMantineProps(), API imperativa di
# @mantine/modals (openMantineConfirmModal(), niente Modal() da dichiarare
# in anticipo), e ModalStack() per piu' modal coordinati aperti insieme.
#
# shiny::runApp(system.file("examples/modals-app.R", package = "shiny.mantine"))

library(shiny)
library(shiny.mantine)

box <- function(title, ...) {
  Stack(
    Title(title, order = 4),
    Paper(withBorder = TRUE, radius = "md", p = "lg", w = 360, ...)
  )
}

ui <- fluidPage(
  MantineProvider(
    ModalsProvider(
      SimpleGrid(
        cols = list(base = 1, md = 3),
        spacing = "lg",
        style = list(padding = "24px"),

        box(
          "Modal() + updateMantineProps()",
          Text(
            "Il modal e' gia' dichiarato in UI; il server lo apre/chiude.",
            size = "xs",
            c = "dimmed",
            mb = "md"
          ),
          Button("Open modal", inputId = "open_basic_btn"),
          Modal(
            "basic_modal",
            inputId = "basic_modal_state",
            title = "Basic modal",
            Text(
              "Contenuto qualsiasi: qui puoi mettere qualunque componente Mantine."
            ),
            Group(mt = "md", Button("Chiudi", inputId = "basic_close_btn"))
          )
        ),

        box(
          "openMantineConfirmModal()",
          Text(
            "API imperativa: nessun Modal() da dichiarare in UI, il server lo crea al volo.",
            size = "xs",
            c = "dimmed",
            mb = "md"
          ),
          Button(
            "Delete item",
            inputId = "delete_btn",
            color = "red",
            variant = "light"
          )
        ),

        box(
          "ModalStack()",
          Text(
            "Piu' modal coordinati (z-index, focus, Escape) che possono restare aperti insieme.",
            size = "xs",
            c = "dimmed",
            mb = "md"
          ),
          Button("Open stack", inputId = "open_stack_btn"),
          ModalStack(
            mantineId = "delete_stack",
            Modal(
              "delete_page",
              inputId = "delete_page_state",
              title = "Delete this page?",
              Text("Puoi recuperarla in seguito dal cestino."),
              Group(
                mt = "md",
                Button("Continue", inputId = "go_to_confirm"),
                Button(
                  "Cancel",
                  inputId = "cancel_stack_btn",
                  variant = "default"
                )
              )
            ),
            Modal(
              "confirm_delete",
              title = "Are you really sure?",
              Text("Questa azione e' permanente."),
              Group(
                mt = "md",
                Button(
                  "Yes, delete",
                  inputId = "confirm_delete_btn",
                  color = "red"
                )
              )
            )
          )
        )
      )
    )
  ),
  tags$hr(),
  verbatimTextOutput("log")
)

server <- function(input, output, session) {
  # --- Modal() singolo -------------------------------------------------
  observeEvent(input$open_basic_btn, {
    updateMantineProps(session, "basic_modal", opened = TRUE)
  })
  observeEvent(input$basic_close_btn, {
    updateMantineProps(session, "basic_modal", opened = FALSE)
  })

  # --- Modal imperativo (@mantine/modals) -------------------------------
  observeEvent(input$delete_btn, {
    openMantineConfirmModal(
      session,
      inputId = "confirm_delete_result",
      title = "Confirm deletion",
      children = "This action cannot be undone. Continue?",
      labels = list(confirm = "Delete", cancel = "Cancel"),
      confirmProps = list(color = "red")
    )
  })

  # --- ModalStack() -------------------------------------------------
  observeEvent(input$open_stack_btn, {
    updateMantineProps(session, "delete_page", opened = TRUE)
  })
  observeEvent(input$go_to_confirm, {
    updateMantineProps(session, "confirm_delete", opened = TRUE)
  })
  observeEvent(input$cancel_stack_btn, {
    updateMantineProps(session, "delete_stack", closeAll = TRUE)
  })
  observeEvent(input$confirm_delete_btn, {
    updateMantineProps(session, "delete_stack", closeAll = TRUE)
  })

  output$log <- renderPrint({
    list(
      basic_modal_state = input$basic_modal_state,
      confirm_delete_result = input$confirm_delete_result,
      go_to_confirm_clicks = input$go_to_confirm,
      confirm_delete_btn_clicks = input$confirm_delete_btn
    )
  })
}

shinyApp(ui, server)
