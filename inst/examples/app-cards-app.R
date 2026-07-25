# Demo categoria "App cards" (https://ui.mantine.dev/category/app-cards/):
# card con griglia di azioni, card con badge, card con statistiche, card con
# icone funzionalita', stats card con progress ring, card con switch, tasks
# card. Composizione di Card/Paper/Badge/Progress/RingProgress/Switch/Avatar
# gia' presenti nel pacchetto.
#
# shiny::runApp(system.file("examples/app-cards-app.R", package = "shiny.mantine"))

library(shiny)
library(shiny.mantine)

ui <- fluidPage(
  MantineProvider(
    Container(
      size = "lg",
      py = "xl",

      Title("Card with badges", order = 3, mb = "sm"),
      Card(
        withBorder = TRUE,
        radius = "md",
        p = "lg",
        w = 320,
        Image(
          src = "https://placehold.co/320x140?text=Verudela+Beach",
          h = 140,
          alt = "Spiaggia",
          radius = "md"
        ),
        Group(
          justify = "space-between",
          mt = "md",
          Text("Verudela Beach, Croatia", fw = 500)
        ),
        Text(
          "Spiaggia sabbiosa a due passi dal centro, ideale per famiglie.",
          size = "sm",
          c = "dimmed"
        ),
        Group(
          mt = "md",
          gap = "xs",
          Badge("🏖️ Sabbia", variant = "light"),
          Badge("🚗 Parcheggio", variant = "light"),
          Badge("🍽️ Ristoranti", variant = "light")
        )
      ),

      Divider(my = "xl"),

      Title("Card with stats", order = 3, mb = "sm"),
      Card(
        withBorder = TRUE,
        radius = "md",
        p = "lg",
        w = 320,
        Text("Running challenge", fw = 500),
        Text(
          "Obiettivo: 100 km questo mese",
          size = "sm",
          c = "dimmed",
          mb = "sm"
        ),
        Progress(value = 68, mb = "sm"),
        Group(
          justify = "space-between",
          Text("68 km", fw = 700),
          Text("32 km rimanenti", size = "sm", c = "dimmed")
        )
      ),

      Divider(my = "xl"),

      Title("Card with icon features", order = 3, mb = "sm"),
      Card(
        withBorder = TRUE,
        radius = "md",
        p = "lg",
        w = 320,
        Text("Tesla Model S", fw = 600, size = "lg"),
        Text("$168.00 al giorno", c = "blue", fw = 500, mb = "sm"),
        Stack(
          gap = "xs",
          Group(
            gap = "xs",
            ThemeIcon(IconTrendingUp(size = 14), variant = "light", size = 22),
            Text("0-100 km/h in 2.1s", size = "sm")
          ),
          Group(
            gap = "xs",
            ThemeIcon(IconMapPin(size = 14), variant = "light", size = 22),
            Text("Autonomia 650 km", size = "sm")
          ),
          Group(
            gap = "xs",
            ThemeIcon(IconStar(size = 14), variant = "light", size = 22),
            Text("5 posti, autopilota incluso", size = "sm")
          )
        ),
        Button(
          "Prenota ora",
          inputId = "book_tesla",
          variant = "filled",
          fullWidth = TRUE,
          mt = "md"
        )
      ),

      Divider(my = "xl"),

      Title("Stats card with progress (ring)", order = 3, mb = "sm"),
      Card(
        withBorder = TRUE,
        radius = "md",
        p = "lg",
        w = 320,
        Group(
          justify = "space-between",
          Stack(
            gap = 0,
            Text("Project tasks", fw = 500),
            Text("23 di 36 completate", size = "sm", c = "dimmed")
          ),
          RingProgress(
            size = 70,
            thickness = 6,
            sections = list(list(value = round(23 / 36 * 100), color = "teal")),
            label = Text(
              paste0(round(23 / 36 * 100), "%"),
              ta = "center",
              size = "xs",
              fw = 700
            )
          )
        )
      ),

      Divider(my = "xl"),

      Title("Card with switches", order = 3, mb = "sm"),
      Card(
        withBorder = TRUE,
        radius = "md",
        p = "lg",
        w = 320,
        Text("Preferenze notifiche", fw = 500, mb = "sm"),
        Stack(
          Switch(
            inputId = "notif_email",
            label = "Notifiche email",
            value = TRUE
          ),
          Switch(
            inputId = "notif_push",
            label = "Notifiche push",
            value = TRUE
          ),
          Switch(inputId = "notif_sms", label = "Notifiche SMS", value = FALSE)
        )
      ),

      Divider(my = "xl"),

      Title("Tasks card", order = 3, mb = "sm"),
      Card(
        withBorder = TRUE,
        radius = "md",
        p = "lg",
        w = 320,
        Group(
          justify = "space-between",
          Text("5.3 minor release", fw = 500),
          Badge("23/36", variant = "light")
        ),
        Progress(value = round(23 / 36 * 100), mt = "sm", mb = "sm"),
        Group(
          Avatar("AC", color = "blue", radius = "xl", size = "sm"),
          Avatar("MR", color = "grape", radius = "xl", size = "sm"),
          Avatar("+3", color = "gray", radius = "xl", size = "sm")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$book_tesla, {
    showNotification("Prenotazione Tesla Model S effettuata (demo)!")
  })
}

shinyApp(ui, server)
