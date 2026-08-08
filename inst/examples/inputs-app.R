# Demo categoria "Inputs" (https://ui.mantine.dev/category/inputs/): 14
# varianti. Alcune ricette di ui.mantine.dev sono puro styling CSS (floating
# label, validazione custom): qui usiamo le props native di Mantine che
# ottengono un effetto equivalente, senza reinventare CSS custom.
#
# shiny::runApp(system.file("examples/inputs-app.R", package = "shiny.mantine"))

library(shiny)
library(shiny.mantine)

box <- function(title, ...) {
  Stack(
    Title(title, order = 4),
    Paper(withBorder = TRUE, radius = "md", p = "md", w = 320, ...)
  )
}

ui <- fluidPage(
  MantineProvider(
    SimpleGrid(
      cols = list(base = 1, md = 2, lg = 3),
      spacing = "lg",
      style = list(padding = "24px"),

      box(
        "Autocomplete async data",
        Autocomplete(
          inputId = "input_async",
          label = "Cerca utente",
          placeholder = "Digita per cercare...",
          data = c("Aldo Caumo", "Maria Rossi", "Luca Bianchi"),
          description = "Demo statica (in un'app reale popoleresti `data` da observeEvent + updateMantineAutocomplete())"
        )
      ),

      box(
        "Card with checkbox",
        Paper(
          withBorder = TRUE,
          radius = "md",
          p = "sm",
          Checkbox(
            inputId = "input_card_chk",
            label = "Accetto i termini di servizio"
          )
        )
      ),

      box(
        "Number input with currency select",
        Group(
          wrap = "nowrap",
          NumberInput(
            inputId = "input_amount",
            label = "Importo",
            value = 100,
            style = list(flex = 1)
          ),
          Select(
            inputId = "input_currency",
            label = "Valuta",
            value = "EUR",
            data = c("EUR", "USD", "CAD", "GBP", "AUD"),
            w = 90
          )
        )
      ),

      box(
        "Custom switch",
        Switch(
          inputId = "input_custom_switch",
          label = "Modalita' aereo",
          onLabel = "ON",
          offLabel = "OFF",
          size = "md"
        )
      ),

      box(
        "Input with floating label",
        TextInput(
          inputId = "input_floating",
          label = "Email",
          placeholder = "La label si comporta come 'floating' se stilizzata via CSS custom (qui usiamo la label standard)"
        )
      ),

      box(
        "Forgot password on input label",
        PasswordInput(
          inputId = "input_forgot_pwd",
          label = Group(
            justify = "space-between",
            w = "100%",
            Text("Password", size = "sm", fw = 500),
            Anchor("Password dimenticata?", href = "#", size = "xs")
          )
        )
      ),

      box(
        "Gradient segmented control",
        SegmentedControl(
          inputId = "input_gradient_seg",
          fullWidth = TRUE,
          size = "xs",
          data = c("All", "AI/ML", "C++", "Rust", "TypeScript"),
          color = "blue"
        )
      ),

      box(
        "Checkbox with image",
        SimpleGrid(
          cols = 2,
          Paper(
            withBorder = TRUE,
            radius = "md",
            p = "xs",
            Stack(
              align = "center",
              Image(
                src = "https://placehold.co/100x70?text=Beach",
                h = 70,
                radius = "sm"
              ),
              Checkbox(inputId = "input_img_beach", label = "Spiaggia")
            )
          ),
          Paper(
            withBorder = TRUE,
            radius = "md",
            p = "xs",
            Stack(
              align = "center",
              Image(
                src = "https://placehold.co/100x70?text=Mountain",
                h = 70,
                radius = "sm"
              ),
              Checkbox(inputId = "input_img_mountain", label = "Montagna")
            )
          )
        )
      ),

      box(
        "Inputs with tooltip",
        TextInput(
          inputId = "input_tooltip",
          label = "Codice invito",
          rightSection = Tooltip(
            label = "Trovi il codice nella mail di invito",
            position = "top",
            withArrow = TRUE,
            ActionIcon(
              IconSettings(size = 14),
              variant = "subtle",
              color = "gray"
            )
          )
        )
      ),

      box(
        "Input with custom validation styles",
        TextInput(
          inputId = "input_validation",
          label = "Username",
          value = "ab",
          error = "Deve contenere almeno 3 caratteri"
        )
      ),

      box(
        "Input with contained button",
        TextInput(
          inputId = "input_contained_btn",
          placeholder = "Cerca...",
          rightSectionWidth = 70,
          rightSection = Button(
            "Cerca",
            inputId = "input_contained_btn_go",
            size = "xs",
            variant = "filled"
          )
        )
      ),

      box(
        "Language picker",
        Select(
          inputId = "input_lang",
          label = "Lingua",
          value = "it",
          data = list(
            list(value = "it", label = "🇮🇹 Italiano"),
            list(value = "en", label = "🇬🇧 English"),
            list(value = "fr", label = "🇫🇷 Français"),
            list(value = "de", label = "🇩🇪 Deutsch")
          )
        )
      ),

      box(
        "Password with strength meter",
        PasswordInput(
          inputId = "input_pwd_strength",
          label = "Password",
          description = "Minimo 8 caratteri, una maiuscola, un numero"
        ),
        Progress(value = 40, color = "orange", mt = "xs", size = "sm"),
        Text("Forza: media (demo statica)", size = "xs", c = "dimmed", mt = 4)
      )
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$input_contained_btn_go, {
    showNotification(paste("Ricerca:", input$input_contained_btn %||% ""))
  })
}

shinyApp(ui, server)
