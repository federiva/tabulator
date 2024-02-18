devtools::load_all()
library(shiny)
library(tabulator)


input_data <- data.frame(
  `id..a` = c(1:5),
  `id..b` = c(6:10),
  idc = c(11:15)
)
ui <- fluidPage(
  tabulatorOutput("table")
)


server <- function(input, output, session) {

    output$table <- renderTabulator({
      tabulator(input_data) |>
        tabulator_options(
          nestedFieldSeparator = "__"
        )
    })

}

shinyApp(ui, server)
