library(shiny)
library(tabulator)

ui <- fluidPage(
  div(
    class = "help-container",
    h2("About this example"),
    h3("Spreadsheets"),
    wellPanel(
      p(
        "This section provides sample cases that demonstrate the usage of column
        definitions and the usage of custom callbacks in formatter functions."
      ),
      p(
        span("Further assistance can be accessed by exploring the "),
        tags$a(
          href = "https://tabulator.info/docs/6.0/spreadsheet",
          target = "_blank",
          "Tabulator's documentation."
        )
      )
    )
  ),
  div(
    class = "table-container",
    tabulatorOutput(outputId = "table")
  ),
  highlighter_ui()
)

# Adding more data to our sample dataset
people_data$line_wrapping <- "Lorem ipsum dolor sit amet, elit consectetur adipisicing "
# Adding random numbers
people_data$money <- round(runif(10, 10e2, 10e4), 2)


server <- function(input, output, session) {

  output$table <- renderTabulator({
    tabulator(
      theme = "site"
    )  |>
    spreadsheet(

    )
  })

  highlighter_server(input, output, "sheet")
}

shinyApp(ui, server)
