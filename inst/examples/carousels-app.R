# Demo categoria "Carousels" (https://ui.mantine.dev/category/carousels/):
# carousel con card responsive, card con carousel di immagini. Usa
# Carousel()/CarouselSlide() (basati su @mantine/carousel + embla-carousel).
#
# shiny::runApp(system.file("examples/carousels-app.R", package = "shiny.mantine"))

library(shiny)
library(shiny.mantine)

destinations <- list(
  list(
    title = "Verudela Beach",
    place = "Croazia",
    img = "https://placehold.co/400x220?text=Verudela+Beach"
  ),
  list(
    title = "Zavratnica Bay",
    place = "Croazia",
    img = "https://placehold.co/400x220?text=Zavratnica+Bay"
  ),
  list(
    title = "Dolomites",
    place = "Italia",
    img = "https://placehold.co/400x220?text=Dolomites"
  ),
  list(
    title = "Amalfi Coast",
    place = "Italia",
    img = "https://placehold.co/400x220?text=Amalfi+Coast"
  )
)

ui <- fluidPage(
  MantineProvider(
    Container(
      size = "lg",
      py = "xl",

      Title("Carousel with cards", order = 3, mb = "sm"),
      Carousel(
        height = 260,
        slideSize = "33.333333%",
        slideGap = "md",
        align = "start",
        withIndicators = FALSE,
        lapply(destinations, function(d) {
          CarouselSlide(
            Card(
              withBorder = TRUE,
              radius = "md",
              p = 0,
              h = 240,
              Image(src = d$img, h = 140),
              Stack(
                gap = 4,
                p = "sm",
                Text(d$title, fw = 500, size = "sm"),
                Text(d$place, size = "xs", c = "dimmed"),
                Button(
                  "Leggi l'articolo",
                  inputId = paste0(
                    "read_",
                    gsub("[^A-Za-z0-9]+", "_", d$title)
                  ),
                  variant = "light",
                  size = "xs",
                  mt = "xs"
                )
              )
            )
          )
        })
      ),

      Divider(my = "xl"),

      Title("Card with carousel", order = 3, mb = "sm"),
      Card(
        withBorder = TRUE,
        radius = "md",
        p = 0,
        w = 400,
        Carousel(
          height = 220,
          withIndicators = TRUE,
          loop = TRUE,
          lapply(destinations, function(d) {
            CarouselSlide(Image(src = d$img, h = 220))
          })
        ),
        Stack(
          p = "md",
          Text("Amalfi Coast, Italia", fw = 600),
          Text("$220 a notte — vista mare inclusa", size = "sm", c = "dimmed"),
          Button(
            "Prenota",
            inputId = "book_amalfi",
            variant = "filled",
            mt = "xs"
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$book_amalfi, {
    showNotification("Prenotazione Amalfi Coast effettuata (demo)!")
  })
}

shinyApp(ui, server)
