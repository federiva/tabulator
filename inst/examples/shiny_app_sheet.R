library(shiny)
library(tabulator)
library(jsonlite)

ui <- fluidPage(
  tags$head(
    tags$style(
      ".table-container{
        padding: 2rem;
        margin-top: 2rem;
      }"
    )
  ),
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
    h3("Empty Spreadsheet"),
    tabulatorOutput(outputId = "table_empty")
  ),
  div(
    class = "table-container",
    h3("Spreadsheet with custom data"),
    tabulatorOutput(outputId = "table_data")
  ),
  div(
    class = "table-container",
    h3("Editable Spreadsheet with multiple tabs"),
    tabulatorOutput(outputId = "table_tabs")
  ),
  highlighter_ui()
)

# Adding more data to our sample dataset
people_data$line_wrapping <- "Lorem ipsum dolor sit amet, elit consectetur adipisicing "
# Adding random numbers
people_data$money <- round(runif(10, 10e2, 10e4), 2)


server <- function(input, output, session) {

  output$table_empty <- renderTabulator({
    tabulator()  |>
    spreadsheet()
  })

  output$table_data <- renderTabulator({
    tabulator()  |>
      spreadsheet(data = people_data)
  })

  output$table_tabs <- renderTabulator({
    tabulator()  |>
      spreadsheet(
        editTriggerEvent = "dblclick",
        spreadsheetColumnDefinition = list(editor = "input"),
        rowHeader = list(
          field = "_id",
          hozAlign = "center",
          headerSort = FALSE,
          frozen = TRUE
        ),
        spreadsheetSheets = list(
          sheet("People Data", key = "people", data = people_data),
          sheet("Iris", key = "iris", data = datasets::iris)
        )
      ) |>
        enable_copy_paste() |>
        enable_range_selection() |>
        subscribe_events(c("rowUpdated"))
  })

  observe({
    showNotification(
      paste(
        "Spreadsheet edited",
        jsonlite::toJSON(input$table_tabs_edited, pretty = TRUE),
        jsonlite::toJSON(input$table_tabs_rowUpdated, pretty = TRUE)
      )
    )
  }) |> bindEvent(
    input$table_tabs_edited,
    input$table_tabs_rowUpdated
  )

  highlighter_server(input, output, "sheet")
}

shinyApp(ui, server)
