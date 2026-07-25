# Demo "Advanced primitives": i componenti compound/a basso livello per
# layout completamente custom - Modal.Root/Drawer.Root/Pagination.Root/
# Spotlight.Root, la famiglia Input, gli slider standalone di ColorPicker
# (Hue/Alpha/Angle), FocusTrap()/RemoveScroll(), MantineThemeProvider(),
# RadioIndicator()/CheckboxIndicator(), piccole icone interne di Mantine e
# le sezioni non interattive di ButtonGroup()/ActionIconGroup().
#
# shiny::runApp(system.file("examples/advanced-primitives-app.R", package = "shiny.mantine"))

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
    SimpleGrid(
      cols = list(base = 1, md = 2, lg = 3),
      spacing = "lg",
      style = list(padding = "24px"),

      box(
        "Modal.Root (layout custom)",
        Text(
          "Componibile a mano invece di usare Modal() tutto-in-uno.",
          size = "xs",
          c = "dimmed",
          mb = "md"
        ),
        Button("Apri modal custom", inputId = "open_custom_modal"),
        ModalRoot(
          "custom_modal",
          inputId = "custom_modal_state",
          ModalOverlay(),
          ModalContent(
            ModalHeader(ModalTitle("Layout custom"), ModalCloseButton()),
            ModalBody(Text(
              "Contenuto composto con ModalHeader/ModalTitle/ModalBody."
            ))
          )
        )
      ),

      box(
        "Drawer.Root (layout custom)",
        Text(
          "Stessa idea di ModalRoot(), per Drawer().",
          size = "xs",
          c = "dimmed",
          mb = "md"
        ),
        Button("Apri drawer custom", inputId = "open_custom_drawer"),
        DrawerRoot(
          "custom_drawer",
          inputId = "custom_drawer_state",
          DrawerOverlay(),
          DrawerContent(
            DrawerHeader(DrawerTitle("Drawer custom"), DrawerCloseButton()),
            DrawerBody(Text(
              "Contenuto composto con DrawerHeader/DrawerTitle/DrawerBody."
            ))
          )
        )
      ),

      box(
        "Pagination.Root (layout custom)",
        Text(
          "PaginationFirst/Previous/Items/Next/Last leggono la pagina corrente da soli.",
          size = "xs",
          c = "dimmed",
          mb = "md"
        ),
        Group(
          justify = "center",
          PaginationRoot(
            inputId = "page",
            total = 10,
            PaginationFirst(),
            PaginationPrevious(),
            PaginationItems(),
            PaginationNext(),
            PaginationLast()
          )
        ),
        Text(textOutput("page_out"), size = "sm", mt = "xs")
      ),

      box(
        "Spotlight.Root (Cmd/Ctrl+K, azioni raggruppate)",
        Text(
          "A differenza di Spotlight(), il filtraggio per query va gestito dall'app.",
          size = "xs",
          c = "dimmed",
          mb = "md"
        ),
        SpotlightRoot(
          SpotlightSearch(placeholder = "Search..."),
          SpotlightActionsList(
            SpotlightActionsGroup(
              label = "Navigazione",
              SpotlightAction("spotlight_choice", "home", label = "Home"),
              SpotlightAction(
                "spotlight_choice",
                "settings",
                label = "Impostazioni"
              )
            )
          )
        ),
        Text(textOutput("spotlight_out"), size = "sm")
      ),

      box(
        "Input, InputWrapper e famiglia",
        InputWrapper(
          label = "Campo con InputWrapper()",
          description = "Label/descrizione/errore attorno a un Input() qualsiasi",
          mb = "sm",
          Input(
            placeholder = "Non sincronizzato con Shiny",
            leftSection = IconSearch(size = 16)
          )
        ),
        Stack(
          gap = 4,
          InputLabel("Composizione manuale"),
          InputDescription(
            "InputLabel()/InputDescription() usati singolarmente"
          ),
          Input(placeholder = "...")
        )
      ),

      box(
        "HueSlider / AlphaSlider / AngleSlider",
        Text("Hue", size = "xs"),
        HueSlider(inputId = "hue_val", value = 210),
        Text("Alpha", size = "xs", mt = "sm"),
        AlphaSlider(inputId = "alpha_val", color = "#228be6", value = 0.7),
        Text("Angle", size = "xs", mt = "sm"),
        Group(
          justify = "center",
          AngleSlider(inputId = "angle_val", value = 45)
        ),
        Text(textOutput("colorsliders_out"), size = "sm", mt = "xs")
      ),

      box(
        "MantineThemeProvider()",
        Text(
          paste(
            "Aggiorna il tema esposto via useMantineTheme() per codice custom.",
            "NON ridipinge i componenti standard: i due bottoni sotto restano",
            "identici (blu), perche' leggono il colore dalle variabili CSS",
            "impostate una sola volta dal MantineProvider() piu' esterno."
          ),
          size = "xs",
          c = "dimmed",
          mb = "md"
        ),
        Group(
          Button("Fuori dal provider", inputId = "btn_outside"),
          MantineThemeProvider(
            theme = list(primaryColor = "red"),
            Button("Dentro (resta blu)", inputId = "btn_inside")
          )
        )
      ),

      box(
        "FocusTrap() / RemoveScroll()",
        Text(
          "Meccanismi usati da Modal()/Drawer(); utili per overlay completamente custom.",
          size = "xs",
          c = "dimmed",
          mb = "md"
        ),
        Switch(
          inputId = "trap_active",
          label = "Focus trap attivo",
          value = TRUE
        ),
        FocusTrap(
          mantineId = "focus_panel",
          active = TRUE,
          Paper(
            withBorder = TRUE,
            p = "sm",
            mt = "xs",
            Stack(
              gap = "xs",
              TextInput(
                inputId = "trap_field1",
                label = "Campo 1",
                placeholder = "Tab per navigare"
              ),
              TextInput(inputId = "trap_field2", label = "Campo 2")
            )
          )
        ),
        Switch(
          inputId = "scroll_locked",
          label = "Blocca lo scroll della pagina",
          mt = "md"
        ),
        RemoveScroll(
          mantineId = "scroll_lock_zone",
          enabled = FALSE,
          Paper(
            withBorder = TRUE,
            p = "sm",
            mt = "xs",
            Text(
              "Con lo scroll bloccato, la rotellina del mouse non scrolla la pagina.",
              size = "xs"
            )
          )
        )
      ),

      box(
        "RadioIndicator() / CheckboxIndicator()",
        Text(
          "Il look \"selezionato\" di Radio()/Checkbox(), senza un input reale dietro.",
          size = "xs",
          c = "dimmed",
          mb = "md"
        ),
        Group(
          RadioIndicator(checked = TRUE),
          CheckboxIndicator(checked = TRUE),
          CheckboxIndicator(indeterminate = TRUE)
        )
      ),

      box(
        "Icone interne di Mantine",
        Text(
          "CheckIcon/CloseIcon/AccordionChevron/RadioIcon - non da Tabler.",
          size = "xs",
          c = "dimmed",
          mb = "md"
        ),
        Group(
          CheckIcon(size = 20),
          CloseIcon(size = 20),
          AccordionChevron(size = 20),
          RadioIcon(size = 20)
        )
      ),

      box(
        "ButtonGroupSection() / ActionIconGroupSection()",
        Text(
          "Sezione non interattiva (es. un'etichetta) tra bottoni/icone raggruppati.",
          size = "xs",
          c = "dimmed",
          mb = "md"
        ),
        ButtonGroup(
          Button("Sinistra", inputId = "left_btn"),
          ButtonGroupSection(Text("o", size = "xs")),
          Button("Destra", inputId = "right_btn")
        )
      )
    )
  ),
  tags$hr(),
  verbatimTextOutput("log")
)

server <- function(input, output, session) {
  # --- Modal.Root / Drawer.Root ------------------------------------------
  observeEvent(input$open_custom_modal, {
    updateMantineProps(session, "custom_modal", opened = TRUE)
  })
  observeEvent(input$open_custom_drawer, {
    updateMantineProps(session, "custom_drawer", opened = TRUE)
  })

  # --- Pagination.Root -----------------------------------------------------
  output$page_out <- renderText(paste("Pagina:", input$page %||% 1))

  # --- Spotlight.Root -----------------------------------------------------
  output$spotlight_out <- renderText({
    req(input$spotlight_choice)
    paste("Scelto:", input$spotlight_choice)
  })

  # --- HueSlider / AlphaSlider / AngleSlider -------------------------------
  output$colorsliders_out <- renderText({
    paste0(
      "hue=",
      input$hue_val %||% "",
      ", alpha=",
      input$alpha_val %||% "",
      ", angle=",
      input$angle_val %||% ""
    )
  })

  # --- FocusTrap / RemoveScroll ---------------------------------------------
  observeEvent(input$trap_active, {
    updateMantineProps(session, "focus_panel", active = input$trap_active)
  })
  observeEvent(input$scroll_locked, {
    updateMantineProps(
      session,
      "scroll_lock_zone",
      enabled = input$scroll_locked
    )
  })

  output$log <- renderPrint({
    list(
      custom_modal_state = input$custom_modal_state,
      custom_drawer_state = input$custom_drawer_state,
      page = input$page,
      spotlight_choice = input$spotlight_choice,
      hue_val = input$hue_val,
      alpha_val = input$alpha_val,
      angle_val = input$angle_val,
      trap_active = input$trap_active,
      scroll_locked = input$scroll_locked
    )
  })
}

shinyApp(ui, server)
