# Demo categoria "Headers" (https://ui.mantine.dev/category/headers/): header
# con piu' livelli, header con mega menu, header con menu a tendina, header
# con ricerca, header semplice, header con tabs. Ogni variante e' un
# riquadro indipendente (barra orizzontale), come su ui.mantine.dev — per un
# header dentro un vero AppShellHeader() vedi inst/examples/appshell-app.R
# (che usa gia' Tabs sincronizzate + search bar).
#
# shiny::runApp(system.file("examples/headers-app.R", package = "shiny.mantine"))

library(shiny)
library(shiny.mantine)

headerBar <- function(title, ...) {
  Stack(
    Title(title, order = 3),
    Paper(withBorder = TRUE, radius = "md", p = "sm", ...)
  )
}

ui <- fluidPage(
  MantineProvider(
    Stack(
      gap = "xl",
      p = "xl",

      headerBar(
        "Simple header",
        Group(
          justify = "space-between",
          ThemeIcon(
            IconLayoutDashboard(size = 16),
            variant = "light",
            size = 28,
            radius = "md"
          ),
          Group(
            Anchor("Home", href = "#", size = "sm"),
            Anchor("Funzionalita'", href = "#", size = "sm"),
            Anchor("Prezzi", href = "#", size = "sm")
          ),
          Button(
            "Accedi",
            inputId = "header_login",
            variant = "filled",
            size = "xs"
          )
        )
      ),

      headerBar(
        "Header with multiple layers",
        Stack(
          gap = "xs",
          Group(
            justify = "space-between",
            Text("supporto@shiny.mantine.dev", size = "xs", c = "dimmed"),
            Group(
              gap = "xs",
              ActionIcon(
                IconBrandTwitter(size = 14),
                variant = "subtle",
                size = "sm"
              ),
              ActionIcon(
                IconBrandInstagram(size = 14),
                variant = "subtle",
                size = "sm"
              )
            )
          ),
          Divider(),
          Group(
            justify = "space-between",
            ThemeIcon(
              IconLayoutDashboard(size = 16),
              variant = "light",
              size = 28,
              radius = "md"
            ),
            Group(
              Anchor("Home", href = "#", size = "sm"),
              Anchor("Prodotti", href = "#", size = "sm"),
              Anchor("Contatti", href = "#", size = "sm")
            )
          )
        )
      ),

      headerBar(
        "Header with menus",
        Group(
          justify = "space-between",
          ThemeIcon(
            IconLayoutDashboard(size = 16),
            variant = "light",
            size = 28,
            radius = "md"
          ),
          Group(
            Menu(
              MenuTarget(UnstyledButton(Group(
                gap = 4,
                Text("Prodotto", size = "sm"),
                IconChevronDown(size = 14)
              ))),
              MenuDropdown(
                menuItem("header_menu", "funzionalita", "Funzionalita'"),
                menuItem("header_menu", "prezzi", "Prezzi"),
                menuItem("header_menu", "changelog", "Changelog")
              )
            ),
            Menu(
              MenuTarget(UnstyledButton(Group(
                gap = 4,
                Text("Risorse", size = "sm"),
                IconChevronDown(size = 14)
              ))),
              MenuDropdown(
                menuItem("header_menu", "docs", "Documentazione"),
                menuItem("header_menu", "blog", "Blog")
              )
            )
          ),
          Button(
            "Registrati",
            inputId = "header_signup",
            variant = "filled",
            size = "xs"
          )
        )
      ),

      headerBar(
        "Header with search",
        Group(
          justify = "space-between",
          ThemeIcon(
            IconLayoutDashboard(size = 16),
            variant = "light",
            size = 28,
            radius = "md"
          ),
          Group(
            Anchor("Home", href = "#", size = "sm"),
            Anchor("Funzionalita'", href = "#", size = "sm")
          ),
          TextInput(
            inputId = "header_search",
            placeholder = "Cerca...",
            leftSection = IconSearch(size = 14),
            w = 200
          )
        )
      ),

      headerBar(
        "Header with mega menu",
        Group(
          justify = "space-between",
          Group(
            ThemeIcon(
              IconLayoutDashboard(size = 16),
              variant = "light",
              size = 28,
              radius = "md"
            ),
            HoverCard(
              width = 500,
              position = "bottom-start",
              radius = "md",
              shadow = "md",
              HoverCardTarget(Center(
                style = list(cursor = "pointer"),
                Text("Funzionalita'", size = "sm", mr = 4),
                IconChevronDown(size = 14)
              )),
              HoverCardDropdown(
                SimpleGrid(
                  cols = 2,
                  megaMenuItem(
                    IconChartBar(size = 20),
                    "Dashboard",
                    "Metriche in tempo reale"
                  ),
                  megaMenuItem(
                    IconCode(size = 20),
                    "Componenti",
                    "Libreria di componenti"
                  )
                )
              )
            )
          ),
          Button(
            "Accedi",
            inputId = "header_mega_login",
            variant = "filled",
            size = "xs"
          )
        )
      ),

      headerBar(
        "Header with tabs",
        Group(
          justify = "space-between",
          Group(
            ThemeIcon(
              IconLayoutDashboard(size = 16),
              variant = "light",
              size = 28,
              radius = "md"
            ),
            Tabs(
              inputId = "header_tab",
              variant = "pills",
              TabsList(
                TabsTab("home", "Home"),
                TabsTab("team", "Team"),
                TabsTab("billing", "Fatturazione")
              )
            )
          ),
          Avatar("AC", color = "blue", radius = "xl")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  observeEvent(
    input$header_menu,
    showNotification(paste("Menu:", input$header_menu))
  )
}

shinyApp(ui, server)
