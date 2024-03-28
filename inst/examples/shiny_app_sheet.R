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
        "This section provides sample cases that demonstrate the usage of the
        Tabulator's Spreadsheet module."
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
    tabulatorOutput(outputId = "table_tabs"),
    h3("Actions"),
    div(
      class = "actions-container",
      actionButton(
        inputId = "remove",
        label = "Remove People Sheet"
      ),
      actionButton(
        inputId = "clear",
        label = "Clear Iris Sheet"
      ),
      actionButton(
        inputId = "add",
        label = "Add Sheet"
      ),
      actionButton(
        inputId = "undo",
        label = "Undo"
      )
    )
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
        history = TRUE,
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
        subscribe_events(
          c(
            "sheetAdded", "sheetRemoved", "sheetLoaded", "sheetUpdated",
            "rowAdded"
          )
        )
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

  observe({
    showNotification(
      paste(
        "Sheet added",
        jsonlite::toJSON(input$table_tabs_sheetAdded, pretty = TRUE)
      )
    )
  }) |> bindEvent(
    input$table_tabs_sheetAdded
  )

  observe({
    showNotification(
      paste(
        "Sheet Removed",
        jsonlite::toJSON(input$table_tabs_sheetRemoved, pretty = TRUE)
      )
    )
  }) |> bindEvent(
    input$table_tabs_sheetRemoved
  )
  observe({
    showNotification(
      paste(
        "Sheet Loaded",
        jsonlite::toJSON(input$table_tabs_sheetLoaded, pretty = TRUE)
      )
    )
  }) |> bindEvent(
    input$table_tabs_sheetLoaded
  )

  observeEvent(input$clear, {
    # Clearing the iris sheet
    clear_sheet(table_id = "table_tabs", key = "iris", session = session)
  })

  observeEvent(input$add, {
    # Adding a new sheet
    random_title <- paste0(sample(letters, 5), collapse = "")
    random_data <- data.frame(matrix(round(runif(10 * 10, min = 0, max = 100)), nrow = 10))
    add_sheet(
      data = random_data,
      table_id = "table_tabs",
      title = random_title,
      key = random_title,
      session = session
    )
  })

  observeEvent(input$remove, {
    # Removing the people sheet
    remove_sheet(table_id = "table_tabs", key = "people", session = session)
  })


  observeEvent(input$undo, {
    undo_action("table_tabs")
  })

  highlighter_server(input, output, "sheet")
}

shinyApp(ui, server)
