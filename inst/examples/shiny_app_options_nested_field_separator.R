library(shiny)
library(tabulator)


input_data <- data.frame(
  `id..a` = c(1:5),
  `id..b` = c(6:10),
  idc = c(11:15),
  `id__a` = c(1:5),
  `id___ax` = c(1:5)
)

ui <- fluidPage(
  h2("Example App - Nested Field Separator"),
  wellPanel(
    div(
      p("This example shows how to specify the nested field separator in the options"),
      p("Also shows the issue that appears when using a nested field separator character in the column names")
    )
  ),
  div(
    h3("Source data as is"),
    tableOutput("example_data")
  ),
  div(
    class = "tabulator-container",
    h3("Tabulator table"),
    tabulatorOutput("table")
  ),
  highlighter_ui()
)


server <- function(input, output, session) {

  output$table <- renderTabulator({
    tabulator(input_data) |>
      tabulator_options(
        nestedFieldSeparator = "__"
      )
  })

  output$example_data <- renderTable(input_data)

  highlighter_server(input, output, "nested_field_separator")
}

shinyApp(ui, server)
