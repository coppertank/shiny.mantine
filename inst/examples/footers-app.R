# Demo categoria "Footers" (https://ui.mantine.dev/category/footers/):
# footer con link centrati, footer con link multi-colonna, footer semplice,
# footer con icone social. Composizione di Group/Stack/Text/Anchor/
# ActionIcon/Divider gia' presenti nel pacchetto.
#
# shiny::runApp(system.file("examples/footers-app.R", package = "shiny.mantine"))

library(shiny)
library(shiny.mantine)

linkList <- function(title, links) {
  Stack(
    gap = 4,
    Text(title, fw = 500, size = "sm", mb = 4),
    lapply(links, function(l) Anchor(l, href = "#", size = "sm", c = "dimmed"))
  )
}

ui <- fluidPage(
  MantineProvider(
    Stack(
      gap = "xl",
      p = "xl",

      Stack(
        Title("Simple footer", order = 3),
        Paper(
          withBorder = TRUE,
          p = "md",
          radius = "md",
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
              Anchor("Blog", href = "#", size = "sm"),
              Anchor("Contatti", href = "#", size = "sm")
            )
          )
        )
      ),

      Stack(
        Title("Footer with centered links", order = 3),
        Paper(
          withBorder = TRUE,
          p = "md",
          radius = "md",
          Stack(
            align = "center",
            Group(
              Anchor("Home", href = "#", size = "sm"),
              Anchor("Prezzi", href = "#", size = "sm"),
              Anchor("Supporto", href = "#", size = "sm"),
              Anchor("Termini", href = "#", size = "sm")
            ),
            Text(
              "© 2026 shiny.mantine. Tutti i diritti riservati.",
              size = "xs",
              c = "dimmed"
            )
          )
        )
      ),

      Stack(
        Title("Footer with links", order = 3),
        Paper(
          withBorder = TRUE,
          p = "lg",
          radius = "md",
          Grid(
            GridCol(
              span = list(base = 12, sm = 3),
              Stack(
                gap = 4,
                ThemeIcon(
                  IconLayoutDashboard(size = 16),
                  variant = "light",
                  size = 28,
                  radius = "md"
                ),
                Text(
                  "Wrapper R per Mantine UI dentro Shiny.",
                  size = "sm",
                  c = "dimmed",
                  mt = "xs"
                )
              )
            ),
            GridCol(
              span = list(base = 6, sm = 3),
              linkList("Chi siamo", c("Team", "Carriere", "Contatti"))
            ),
            GridCol(
              span = list(base = 6, sm = 3),
              linkList("Progetto", c("Documentazione", "Esempi", "Changelog"))
            ),
            GridCol(
              span = list(base = 6, sm = 3),
              linkList("Community", c("GitHub", "Discussioni", "Issue"))
            )
          ),
          Divider(my = "md"),
          Text(
            "© 2026 shiny.mantine. Tutti i diritti riservati.",
            size = "xs",
            c = "dimmed"
          )
        )
      ),

      Stack(
        Title("Footer with social icons", order = 3),
        Paper(
          withBorder = TRUE,
          p = "md",
          radius = "md",
          Group(
            justify = "space-between",
            Text("shiny.mantine", fw = 700),
            Group(
              gap = "xs",
              ActionIcon(
                IconBrandTwitter(size = 18),
                variant = "default",
                radius = "xl",
                size = 36
              ),
              ActionIcon(
                IconBrandInstagram(size = 18),
                variant = "default",
                radius = "xl",
                size = 36
              ),
              ActionIcon(
                IconBrandYoutube(size = 18),
                variant = "default",
                radius = "xl",
                size = 36
              ),
              ActionIcon(
                IconBrandLinkedin(size = 18),
                variant = "default",
                radius = "xl",
                size = 36
              )
            )
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)
