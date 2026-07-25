# Demo con navigazione a pagine (client-side, nessun round-trip col server
# per cambiare pagina): AppShell con header, navbar responsive (Burger),
# NavLink con icone, e tre "pagine" (Home / Dashboard / Impostazioni) che si
# scambiano dentro lo stesso Main mantenendo lo stile Mantine.
#
# Per eseguirla dopo aver installato il pacchetto:
#   shiny::runApp(system.file("examples/appshell-app.R", package = "shiny.mantine"))

library(shiny)
library(shiny.mantine)

ui <- tagList(
  MantineProvider(
    defaultColorScheme = "light",

    # Pages() mantiene lo stato di "pagina attiva" lato client: i
    # navLinkItem() nella Navbar e i Page() nel Main condividono lo stesso
    # router perche' sono entrambi annidati qui dentro.
    Pages(
      active = "home",

      AppShell(
        navbar = list(
          width = 260,
          breakpoint = "sm",
          collapsed = list(mobile = TRUE)
        ),
        header = list(height = 60),
        aside = list(
          width = 260,
          breakpoint = "md",
          collapsed = list(mobile = TRUE)
        ),
        footer = list(height = 50),
        padding = "md",

        # --- Header: burger (solo mobile) + logo + tabs + search + avatar ---
        AppShellHeader(
          Group(
            h = "100%",
            px = "md",
            justify = "space-between",
            wrap = "nowrap",
            Group(
              wrap = "nowrap",
              navbarBurger(
                "navOpened",
                opened = FALSE,
                hiddenFrom = "sm",
                size = "sm"
              ),
              ThemeIcon(
                IconLayoutDashboard(size = 18),
                variant = "light",
                color = "blue",
                size = 32,
                radius = "md"
              ),
              Title("shiny.mantine", order = 3),

              # --- Tabs: navigazione alternativa nell'header, sincronizzata
              # con la Navbar tramite lo stesso router Pages() e lo stesso
              # inputId "navId" (cliccare qui o nella Navbar aggiorna entrambi).
              Tabs(
                inputId = "navId",
                variant = "pills",
                visibleFrom = "sm",
                TabsList(
                  TabsTab("home", "Home", leftSection = IconHome2(size = 16)),
                  TabsTab(
                    "dashboard",
                    "Dashboard",
                    leftSection = IconLayoutDashboard(size = 16)
                  ),
                  TabsTab(
                    "settings",
                    "Impostazioni",
                    leftSection = IconSettings(size = 16)
                  ),
                  TabsTab(
                    "buttons",
                    "Bottoni",
                    leftSection = IconPlus(size = 16)
                  )
                )
              )
            ),
            Group(
              wrap = "nowrap",
              TextInput(
                inputId = "search",
                placeholder = "Cerca...",
                leftSection = IconSearch(size = 16),
                w = 220,
                visibleFrom = "xs"
              ),
              Avatar("AC", color = "blue", radius = "xl")
            )
          )
        ),

        # --- Navbar: voci con icone, evidenziazione automatica della pagina attiva ---
        AppShellNavbar(
          p = "md",
          AppShellSection(
            Text(
              "Menu principale",
              fw = 500,
              mb = "xs",
              size = "sm",
              c = "dimmed"
            )
          ),
          AppShellSection(
            grow = TRUE,
            component = "div",
            navLinkItem(
              "navId",
              "home",
              "Home",
              leftSection = IconHome2(size = 18)
            ),
            navLinkItem(
              "navId",
              "dashboard",
              "Dashboard",
              leftSection = IconLayoutDashboard(size = 18)
            ),
            navLinkItem(
              "navId",
              "settings",
              "Impostazioni",
              leftSection = IconSettings(size = 18)
            ),
            navLinkItem(
              "navId",
              "buttons",
              "Bottoni",
              leftSection = IconPlus(size = 18)
            )
          ),
          AppShellSection(
            Divider(mb = "xs"),
            Badge("v0.1.0", variant = "light", color = "gray")
          )
        ),

        # --- Main: una Page() per voce di menu, mostrata/nascosta lato client ---
        AppShellMain(
          Page(
            value = "home",
            Container(
              size = "lg",
              Title("Home", order = 2, mb = "md"),
              Text(
                "Panoramica rapida sui numeri chiave.",
                c = "dimmed",
                mb = "lg"
              ),
              SimpleGrid(
                cols = list(base = 1, sm = 3),
                Paper(
                  shadow = "sm",
                  radius = "md",
                  withBorder = TRUE,
                  p = "lg",
                  Group(
                    justify = "space-between",
                    Stack(
                      gap = 0,
                      Text("Utenti attivi", size = "sm", c = "dimmed"),
                      Title("128", order = 2)
                    ),
                    ThemeIcon(
                      IconUsers(size = 20),
                      size = 40,
                      radius = "md",
                      variant = "light",
                      color = "blue"
                    )
                  )
                ),
                Paper(
                  shadow = "sm",
                  radius = "md",
                  withBorder = TRUE,
                  p = "lg",
                  Group(
                    justify = "space-between",
                    Stack(
                      gap = 0,
                      Text("Progetti", size = "sm", c = "dimmed"),
                      Title("12", order = 2)
                    ),
                    ThemeIcon(
                      IconLayoutDashboard(size = 20),
                      size = 40,
                      radius = "md",
                      variant = "light",
                      color = "grape"
                    )
                  )
                ),
                Paper(
                  shadow = "sm",
                  radius = "md",
                  withBorder = TRUE,
                  p = "lg",
                  Group(
                    justify = "space-between",
                    Stack(
                      gap = 0,
                      Text("Stato", size = "sm", c = "dimmed"),
                      Badge(
                        "Online",
                        color = "green",
                        variant = "light",
                        size = "lg"
                      )
                    ),
                    ThemeIcon(
                      IconSettings(size = 20),
                      size = 40,
                      radius = "md",
                      variant = "light",
                      color = "teal"
                    )
                  )
                )
              )
            )
          ),

          Page(
            value = "dashboard",
            Container(
              size = "lg",
              Title("Dashboard", order = 2, mb = "md"),
              Grid(
                GridCol(
                  span = list(base = 12, sm = 6),
                  Paper(
                    shadow = "sm",
                    radius = "md",
                    withBorder = TRUE,
                    p = "lg",
                    Text("Il tuo nome", fw = 500, mb = "sm"),
                    TextInput(inputId = "nome", placeholder = "Scrivi qui...")
                  )
                ),
                GridCol(
                  span = list(base = 12, sm = 6),
                  Paper(
                    shadow = "sm",
                    radius = "md",
                    withBorder = TRUE,
                    p = "lg",
                    Text("Colore preferito", fw = 500, mb = "sm"),
                    Select(
                      inputId = "colore",
                      placeholder = "Scegli un colore",
                      data = list("blue", "red", "green", "violet")
                    )
                  )
                )
              ),
              Divider(my = "lg"),
              Button(
                "Clicca qui",
                inputId = "btn_click",
                variant = "filled",
                color = "blue"
              )
            )
          ),

          Page(
            value = "settings",
            Container(
              size = "sm",
              Title("Impostazioni", order = 2, mb = "md"),
              Paper(
                shadow = "sm",
                radius = "md",
                withBorder = TRUE,
                p = "lg",
                Stack(
                  Switch(
                    inputId = "notifiche",
                    label = "Notifiche attive",
                    value = TRUE
                  ),
                  Divider(),
                  Switch(
                    inputId = "tema_scuro",
                    label = "Tema scuro (demo, non applicato)",
                    value = FALSE
                  )
                )
              )
            )
          ),

          # --- Pagina "Bottoni": un esempio per ciascuno dei 6 componenti di
          # https://ui.mantine.dev/category/buttons/ ---
          Page(
            value = "buttons",
            Container(
              size = "lg",
              Title("Componenti Button", order = 2, mb = "md"),
              Text(
                "Un esempio di ciascuno dei 6 componenti \"buttons\" di ui.mantine.dev/category/buttons/.",
                c = "dimmed",
                mb = "lg"
              ),
              SimpleGrid(
                cols = list(base = 1, sm = 2),
                spacing = "md",

                Paper(
                  shadow = "sm",
                  radius = "md",
                  withBorder = TRUE,
                  p = "lg",
                  Stack(
                    Text("Color scheme toggle", fw = 500),
                    Group(
                      ColorSchemeToggle(inputId = "color_scheme"),
                      Text(
                        "Alterna il tema chiaro/scuro dell'intera app",
                        size = "sm",
                        c = "dimmed"
                      )
                    )
                  )
                ),

                Paper(
                  shadow = "sm",
                  radius = "md",
                  withBorder = TRUE,
                  p = "lg",
                  Stack(
                    Text("Copy to clipboard button", fw = 500),
                    CopyButton(
                      "https://github.com/tuo-utente/shiny.mantine",
                      label = "Copia link repo",
                      inputId = "copy_link"
                    )
                  )
                ),

                Paper(
                  shadow = "sm",
                  radius = "md",
                  withBorder = TRUE,
                  p = "lg",
                  Stack(
                    Text("Button with menu", fw = 500),
                    ButtonWithMenu(
                      "Crea nuovo",
                      menuItem("menu_action", "progetto", "Progetto"),
                      menuItem("menu_action", "cartella", "Cartella"),
                      MenuDivider(),
                      menuItem("menu_action", "importa", "Importa da file")
                    )
                  )
                ),

                Paper(
                  shadow = "sm",
                  radius = "md",
                  withBorder = TRUE,
                  p = "lg",
                  Stack(
                    Text("Button with loading progress", fw = 500),
                    LoadingProgressButton(
                      "Carica file",
                      inputId = "upload_done",
                      color = "blue",
                      variant = "filled"
                    )
                  )
                ),

                Paper(
                  shadow = "sm",
                  radius = "md",
                  withBorder = TRUE,
                  p = "lg",
                  Stack(
                    Text("Social buttons", fw = 500),
                    Stack(
                      gap = "xs",
                      SocialButton("google", inputId = "social_google"),
                      SocialButton("github", inputId = "social_github"),
                      SocialButton("discord", inputId = "social_discord")
                    )
                  )
                ),

                Paper(
                  shadow = "sm",
                  radius = "md",
                  withBorder = TRUE,
                  p = "lg",
                  Stack(
                    Text("Split button", fw = 500),
                    SplitButton(
                      "Invia",
                      inputId = "send_btn",
                      menuItem("send_action", "now", "Invia ora"),
                      menuItem("send_action", "schedule", "Programma invio")
                    )
                  )
                )
              )
            )
          )
        ),

        # --- Aside: pannello "Dettagli" contestuale, cambia con la pagina attiva ---
        AppShellAside(
          p = "md",
          Page(
            value = "home",
            Stack(
              Text("Dettagli", fw = 500),
              Text(
                "Statistiche aggiornate in tempo reale.",
                size = "sm",
                c = "dimmed"
              )
            )
          ),
          Page(
            value = "dashboard",
            Stack(
              Text("Dettagli", fw = 500),
              Text(
                "Modifica i campi e premi il bottone per testare l'input.",
                size = "sm",
                c = "dimmed"
              )
            )
          ),
          Page(
            value = "settings",
            Stack(
              Text("Dettagli", fw = 500),
              Text(
                "Le preferenze sono salvate solo in sessione (demo).",
                size = "sm",
                c = "dimmed"
              )
            )
          ),
          Page(
            value = "buttons",
            Stack(
              Text("Dettagli", fw = 500),
              Text(
                "Ogni bottone qui sotto invia il suo stato a un input Shiny dedicato.",
                size = "sm",
                c = "dimmed"
              )
            )
          )
        ),

        # --- Footer: barra fissa in fondo alla pagina ---
        AppShellFooter(
          Group(
            h = "100%",
            px = "md",
            justify = "space-between",
            Text("© 2026 shiny.mantine", size = "sm", c = "dimmed"),
            Group(
              Text("Documentazione", size = "sm"),
              Text("GitHub", size = "sm")
            )
          )
        )
      )
    )
  ),
  tags$div(style = "padding: 8px 24px;", textOutput("riepilogo"))
)

server <- function(input, output, session) {
  observeEvent(input$btn_click, {
    showNotification("Bottone Mantine cliccato!")
  })

  observeEvent(input$menu_action, {
    showNotification(paste("Menu:", input$menu_action))
  })

  observeEvent(input$send_btn, {
    showNotification("Invio effettuato!")
  })

  observeEvent(input$send_action, {
    showNotification(paste("Split button:", input$send_action))
  })

  observeEvent(input$upload_done, {
    showNotification("Caricamento completato!")
  })

  observeEvent(input$copy_link, {
    showNotification(paste("Copiato:", input$copy_link))
  })

  lapply(c("social_google", "social_github", "social_discord"), function(id) {
    observeEvent(
      input[[id]],
      {
        showNotification(paste("Click su", id))
      },
      ignoreInit = TRUE
    )
  })

  output$riepilogo <- renderText({
    paste(
      "Nome:",
      input$nome %||% "-",
      "| Colore:",
      input$colore %||% "-",
      "| Pagina attiva:",
      input$navId %||% "home",
      "| Notifiche:",
      input$notifiche %||% "-",
      "| Ricerca:",
      input$search %||% "-",
      "| Tema:",
      input$color_scheme %||% "-",
      "| Upload completato:",
      input$upload_done %||% "-"
    )
  })
}

shinyApp(ui, server)
