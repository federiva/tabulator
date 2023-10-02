devtools::load_all()
library(shiny)
library(tabulator)

ui <- fluidPage(
  tabulatorOutput("table")
)

server <- function(input, output, session) {

    output$table <- renderTabulator({
    tabulator(iris) |>
      column_layout_mode("fitColumns") |>
      set_layout_columns_on_new_data() |>
      pagination(pagination_size = 5, mode = "remote")
  })

}

shinyApp(ui, server)
