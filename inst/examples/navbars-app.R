# Demo categoria "Navbars" (https://ui.mantine.dev/category/navbars/): navbar
# con 2 sezioni, gruppo di link collassabile, navbar con tooltip (e colorata),
# navbar con link annidati, navbar con ricerca, navbar con SegmentedControl,
# navbar semplice (e colorata). Ogni variante e' mostrata come riquadro
# indipendente (come su ui.mantine.dev) — componi la scelta che preferisci
# dentro un vero AppShellNavbar() nella tua app, come gia' fa
# inst/examples/appshell-app.R.
#
# shiny::runApp(system.file("examples/navbars-app.R", package = "shiny.mantine"))

library(shiny)
library(shiny.mantine)

navbarBox <- function(title, ...) {
  Stack(
    Title(title, order = 3),
    Paper(withBorder = TRUE, radius = "md", p = "md", w = 280, ...)
  )
}

ui <- fluidPage(
  MantineProvider(
    SimpleGrid(
      cols = list(base = 1, md = 2),
      spacing = "xl",
      style = list(padding = "24px"),

      navbarBox(
        "Navbar with 2 sections",
        Stack(
          gap = 4,
          Text(
            "Principale",
            size = "xs",
            c = "dimmed",
            tt = "uppercase",
            fw = 700,
            mb = 4
          ),
          NavLink(label = "Home", leftSection = IconHome2(size = 16)),
          NavLink(
            label = "Dashboard",
            leftSection = IconLayoutDashboard(size = 16)
          )
        ),
        Divider(my = "sm"),
        Stack(
          gap = 4,
          Text(
            "Account",
            size = "xs",
            c = "dimmed",
            tt = "uppercase",
            fw = 700,
            mb = 4
          ),
          NavLink(
            label = "Impostazioni",
            leftSection = IconSettings(size = 16)
          ),
          NavLink(
            label = "Esci",
            leftSection = IconLogout(size = 16),
            color = "red"
          )
        )
      ),

      navbarBox(
        "Collapsible links group",
        NavLink(
          label = "Progetti",
          leftSection = IconLayoutDashboard(size = 16),
          defaultOpened = TRUE,
          NavLink(label = "Tutti i progetti"),
          NavLink(label = "Archiviati"),
          NavLink(label = "Preferiti")
        ),
        NavLink(label = "Impostazioni", leftSection = IconSettings(size = 16))
      ),

      navbarBox(
        "Navbar with tooltips",
        Stack(
          gap = "xs",
          Tooltip(
            label = "Home",
            position = "right",
            ActionIcon(IconHome2(size = 18), variant = "subtle", size = "lg")
          ),
          Tooltip(
            label = "Dashboard",
            position = "right",
            ActionIcon(
              IconLayoutDashboard(size = 18),
              variant = "subtle",
              size = "lg"
            )
          ),
          Tooltip(
            label = "Impostazioni",
            position = "right",
            ActionIcon(IconSettings(size = 18), variant = "subtle", size = "lg")
          )
        )
      ),

      navbarBox(
        "Navbar with tooltips (colored)",
        Stack(
          gap = "xs",
          Tooltip(
            label = "Home",
            position = "right",
            color = "blue",
            ActionIcon(
              IconHome2(size = 18),
              variant = "filled",
              color = "blue",
              size = "lg"
            )
          ),
          Tooltip(
            label = "Dashboard",
            position = "right",
            color = "grape",
            ActionIcon(
              IconLayoutDashboard(size = 18),
              variant = "filled",
              color = "grape",
              size = "lg"
            )
          ),
          Tooltip(
            label = "Impostazioni",
            position = "right",
            color = "teal",
            ActionIcon(
              IconSettings(size = 18),
              variant = "filled",
              color = "teal",
              size = "lg"
            )
          )
        )
      ),

      navbarBox(
        "Navbar with nested links",
        Group(
          mb = "sm",
          Avatar("AC", color = "blue", radius = "xl"),
          Stack(
            gap = 0,
            Text("Aldo Caumo", size = "sm", fw = 500),
            Text("Amministratore", size = "xs", c = "dimmed")
          )
        ),
        Divider(mb = "sm"),
        NavLink(
          label = "Componenti",
          leftSection = IconCode(size = 16),
          defaultOpened = TRUE,
          NavLink(label = "Bottoni"),
          NavLink(label = "Input"),
          NavLink(label = "Tabelle")
        ),
        NavLink(label = "Documentazione", leftSection = IconBook(size = 16))
      ),

      navbarBox(
        "Navbar with search",
        TextInput(
          inputId = "nav_search",
          placeholder = "Cerca...",
          leftSection = IconSearch(size = 16),
          mb = "sm"
        ),
        NavLink(label = "Home", leftSection = IconHome2(size = 16)),
        NavLink(
          label = "Dashboard",
          leftSection = IconLayoutDashboard(size = 16)
        ),
        NavLink(
          label = "Attivita' recenti",
          leftSection = IconLayoutDashboard(size = 16),
          NavLink(label = "Oggi"),
          NavLink(label = "Questa settimana")
        )
      ),

      navbarBox(
        "Navbar with SegmentedControl",
        SegmentedControl(
          inputId = "nav_mode",
          data = c("Personale", "Team"),
          fullWidth = TRUE,
          mb = "sm"
        ),
        NavLink(label = "Home", leftSection = IconHome2(size = 16)),
        NavLink(
          label = "Dashboard",
          leftSection = IconLayoutDashboard(size = 16)
        ),
        NavLink(label = "Impostazioni", leftSection = IconSettings(size = 16))
      ),

      navbarBox(
        "Simple navbar",
        NavLink(
          label = "Impostazioni account",
          leftSection = IconSettings(size = 16)
        ),
        NavLink(
          label = "Altre impostazioni",
          leftSection = IconSettings(size = 16)
        )
      ),

      navbarBox(
        "Simple navbar (colored)",
        NavLink(
          label = "Home",
          leftSection = IconHome2(size = 16),
          active = TRUE,
          color = "blue",
          variant = "filled"
        ),
        NavLink(
          label = "Dashboard",
          leftSection = IconLayoutDashboard(size = 16)
        ),
        NavLink(label = "Impostazioni", leftSection = IconSettings(size = 16))
      )
    )
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)
