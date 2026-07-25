# Demo categoria "Sliders" (https://ui.mantine.dev/category/sliders/): slider
# con thumb visibile all'hover, slider con icona sul thumb, NumberInput +
# slider abbinati, range slider con etichette, slider con tacche, slider con
# thumb bianco.
#
# shiny::runApp(system.file("examples/sliders-app.R", package = "shiny.mantine"))

library(shiny)
library(shiny.mantine)

box <- function(title, ...) {
  Stack(
    Title(title, order = 4),
    Paper(withBorder = TRUE, radius = "md", p = "lg", w = 340, ...)
  )
}

ui <- fluidPage(
  MantineProvider(
    SimpleGrid(
      cols = list(base = 1, md = 2, lg = 3),
      spacing = "lg",
      style = list(padding = "24px"),

      box(
        "Slider with thumb visible on hover",
        Text(
          "Il thumb appare solo passandoci sopra col mouse.",
          size = "xs",
          c = "dimmed",
          mb = "md"
        ),
        Slider(inputId = "slider_hover_thumb", value = 40, thumbSize = 14)
      ),

      box(
        "Slider with icon thumb",
        Slider(
          inputId = "slider_icon_thumb",
          value = 50,
          color = "grape",
          thumbChildren = IconHeart(size = 12)
        )
      ),

      box(
        "NumberInput with slider",
        NumberInput(
          inputId = "slider_numberinput",
          label = "Quantita'",
          value = 25,
          min = 0,
          max = 100,
          mb = "xs"
        ),
        Slider(
          inputId = "slider_numberinput_slave",
          value = 25,
          min = 0,
          max = 100
        )
      ),

      box(
        "Range slider with labels",
        RangeSlider(
          inputId = "slider_range_labels",
          value = c(20, 60),
          minRange = 10,
          label = NULL,
          marks = list(
            list(value = 20, label = "20"),
            list(value = 60, label = "60")
          )
        )
      ),

      box(
        "Slider with marks",
        Slider(
          inputId = "slider_marks",
          value = 50,
          marks = list(
            list(value = 0, label = "0"),
            list(value = 25, label = "25"),
            list(value = 50, label = "50"),
            list(value = 75, label = "75"),
            list(value = 100, label = "100")
          )
        )
      ),

      box(
        "Slider with white thumb",
        Box(
          p = "md",
          style = list(
            backgroundColor = "var(--mantine-color-dark-6)",
            borderRadius = 8
          ),
          Slider(
            inputId = "slider_white_thumb",
            value = 60,
            color = "gray",
            styles = list(
              thumb = list(borderColor = "white", backgroundColor = "white")
            )
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  observeEvent(
    input$slider_numberinput,
    {
      updateMantineSlider(
        session,
        "slider_numberinput_slave",
        value = input$slider_numberinput
      )
    },
    ignoreInit = TRUE
  )

  observeEvent(
    input$slider_numberinput_slave,
    {
      updateMantineNumberInput(
        session,
        "slider_numberinput",
        value = input$slider_numberinput_slave
      )
    },
    ignoreInit = TRUE
  )
}

shinyApp(ui, server)
