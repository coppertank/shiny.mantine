# Demo categoria "Buttons" (https://ui.mantine.dev/category/buttons/): color
# scheme toggle, copy to clipboard button, button with menu, button with
# loading progress, social buttons, split button.
#
# shiny::runApp(system.file("examples/buttons-app.R", package = "shiny.mantine"))

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
        "Color scheme toggle",
        Group(justify = "center", ColorSchemeToggle(inputId = "color_scheme"))
      ),

      box(
        "Copy to clipboard button",
        CopyButton(
          value = "https://mantine.dev",
          label = "Copy link to clipboard",
          copiedLabel = "Copied to clipboard",
          inputId = "copy_link",
          variant = "light",
          fullWidth = TRUE
        )
      ),

      box(
        "Button with menu",
        ButtonWithMenu(
          "Create new",
          menuItem(
            "create_new_action",
            "project",
            "New project",
            leftSection = IconPlus(size = 16)
          ),
          menuItem(
            "create_new_action",
            "document",
            "New document",
            leftSection = IconFileText(size = 16)
          ),
          menuItem(
            "create_new_action",
            "import",
            "Import",
            leftSection = IconUpload(size = 16)
          ),
          MenuDivider(),
          menuItem(
            "create_new_action",
            "delete",
            "Delete workspace",
            leftSection = IconTrash(size = 16),
            color = "red"
          )
        )
      ),

      box(
        "Button with loading progress",
        LoadingProgressButton(
          "Upload files",
          inputId = "upload_done",
          loadingLabel = "Uploading...",
          fullWidth = TRUE
        )
      ),

      box(
        "Social buttons",
        Stack(
          gap = "xs",
          SocialButton("google", inputId = "social_google"),
          SocialButton("twitter", inputId = "social_twitter"),
          SocialButton("facebook", inputId = "social_facebook"),
          SocialButton("github", inputId = "social_github"),
          SocialButton("discord", inputId = "social_discord")
        )
      ),

      box(
        "Split button",
        Group(
          justify = "center",
          SplitButton(
            "Send",
            inputId = "send_btn",
            menuItem("send_action", "now", "Send now"),
            menuItem("send_action", "schedule", "Schedule for later"),
            menuItem("send_action", "draft", "Save as draft")
          )
        )
      )
    )
  ),
  tags$hr(),
  verbatimTextOutput("log")
)

server <- function(input, output, session) {
  output$log <- renderPrint({
    list(
      color_scheme = input$color_scheme,
      copy_link_clicks = input$copy_link,
      create_new_action = input$create_new_action,
      upload_done = input$upload_done,
      send_btn_clicks = input$send_btn,
      send_action = input$send_action
    )
  })
}

shinyApp(ui, server)
