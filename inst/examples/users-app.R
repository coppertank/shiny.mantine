# Demo categoria "Users" (https://ui.mantine.dev/category/users/): user
# button, user card con immagine, user card con azione, user info con icone,
# user menu, table con ruoli, users stack, table con utenti. Composizione di
# Avatar/Menu/Table/Badge/Button gia' presenti nel pacchetto.
#
# shiny::runApp(system.file("examples/users-app.R", package = "shiny.mantine"))

library(shiny)
library(shiny.mantine)

people <- list(
  list(
    name = "Aldo Caumo",
    email = "aldo@example.com",
    role = "Sviluppatore",
    rate = "$65/h"
  ),
  list(
    name = "Maria Rossi",
    email = "maria@example.com",
    role = "Designer",
    rate = "$58/h"
  ),
  list(
    name = "Luca Bianchi",
    email = "luca@example.com",
    role = "Project Manager",
    rate = "$72/h"
  )
)

ui <- fluidPage(
  MantineProvider(
    Container(
      size = "lg",
      py = "xl",

      Title("User button", order = 3, mb = "sm"),
      UnstyledButton(
        p = "xs",
        style = list(
          borderRadius = 8,
          border = "1px solid var(--mantine-color-gray-3)"
        ),
        w = 260,
        Group(
          Avatar("AC", color = "blue", radius = "xl"),
          Stack(
            gap = 0,
            Text("Aldo Caumo", size = "sm", fw = 500),
            Text("aldo@example.com", size = "xs", c = "dimmed")
          )
        )
      ),

      Divider(my = "xl"),

      Title("User card with image", order = 3, mb = "sm"),
      Card(
        withBorder = TRUE,
        radius = "md",
        p = "lg",
        w = 300,
        Stack(
          align = "center",
          Avatar(size = 80, radius = 80, color = "blue", "AC"),
          Text("Aldo Caumo", fw = 600, mt = "sm"),
          Text("Full-stack developer", size = "sm", c = "dimmed"),
          Group(
            mt = "md",
            Stack(
              gap = 0,
              align = "center",
              Text("128", fw = 700),
              Text("Follower", size = "xs", c = "dimmed")
            ),
            Stack(
              gap = 0,
              align = "center",
              Text("42", fw = 700),
              Text("Post", size = "xs", c = "dimmed")
            )
          )
        )
      ),

      Divider(my = "xl"),

      Title("User card with action", order = 3, mb = "sm"),
      Card(
        withBorder = TRUE,
        radius = "md",
        p = "lg",
        w = 320,
        Group(
          Avatar("MR", color = "grape", radius = "xl", size = "lg"),
          Stack(
            gap = 0,
            Text("Maria Rossi", fw = 500),
            Text("maria@example.com", size = "sm", c = "dimmed"),
            Text("Designer", size = "xs", c = "dimmed")
          )
        ),
        Button(
          "Invia messaggio",
          inputId = "send_message",
          variant = "light",
          fullWidth = TRUE,
          mt = "md"
        )
      ),

      Divider(my = "xl"),

      Title("User info with icons", order = 3, mb = "sm"),
      Group(
        Avatar("LB", color = "teal", radius = "xl", size = "lg"),
        Stack(
          gap = 4,
          Text("Luca Bianchi", fw = 500),
          Group(
            gap = 4,
            IconMail(size = 14),
            Text("luca@example.com", size = "sm", c = "dimmed")
          ),
          Group(
            gap = 4,
            IconPhone(size = 14),
            Text("+39 555 0102", size = "sm", c = "dimmed")
          )
        )
      ),

      Divider(my = "xl"),

      Title("User menu", order = 3, mb = "sm"),
      Menu(
        MenuTarget(UnstyledButton(Group(
          Avatar("AC", color = "blue", radius = "xl"),
          Text("Aldo Caumo", size = "sm"),
          IconChevronRight(size = 14)
        ))),
        MenuDropdown(
          MenuLabel("Account"),
          menuItem(
            "user_menu",
            "profilo",
            "Profilo",
            leftSection = IconUsers(size = 14)
          ),
          menuItem(
            "user_menu",
            "impostazioni",
            "Impostazioni",
            leftSection = IconSettings(size = 14)
          ),
          MenuDivider(),
          menuItem(
            "user_menu",
            "esci",
            "Esci",
            leftSection = IconLogout(size = 14),
            color = "red"
          )
        )
      ),

      Divider(my = "xl"),

      Title("Users stack", order = 3, mb = "sm"),
      Stack(
        w = 340,
        lapply(people, function(p) {
          Paper(
            withBorder = TRUE,
            p = "sm",
            radius = "md",
            Group(
              justify = "space-between",
              Group(
                Avatar(substr(p$name, 1, 1), color = "blue", radius = "xl"),
                Stack(
                  gap = 0,
                  Text(p$name, size = "sm", fw = 500),
                  Text(p$email, size = "xs", c = "dimmed")
                )
              ),
              Text(p$rate, size = "sm", c = "dimmed")
            )
          )
        })
      ),

      Divider(my = "xl"),

      Title("Table with users / roles", order = 3, mb = "sm"),
      Table(
        highlightOnHover = TRUE,
        TableThead(TableTr(
          TableTh("Utente"),
          TableTh("Email"),
          TableTh("Ruolo"),
          TableTh("Stato")
        )),
        TableTbody(
          lapply(people, function(p) {
            TableTr(
              TableTd(Group(
                Avatar(
                  substr(p$name, 1, 1),
                  color = "blue",
                  radius = "xl",
                  size = "sm"
                ),
                Text(p$name, size = "sm")
              )),
              TableTd(Text(p$email, size = "sm")),
              TableTd(Text(p$role, size = "sm")),
              TableTd(Badge("Attivo", color = "green", variant = "light"))
            )
          })
        )
      )
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$send_message, {
    showNotification("Messaggio inviato a Maria Rossi (demo)!")
  })
  observeEvent(input$user_menu, {
    showNotification(paste("Voce menu utente:", input$user_menu))
  })
}

shinyApp(ui, server)
