library(shiny)
library(tabulator)

ui <- fluidPage(
  div(
    class = "help-container",
    h2("About this example"),
    h3("History API"),
    wellPanel(
      p(
        "This section provides sample cases that demonstrate the usage of the history
        API functions. Basically enabling the user to undo, redo and clear the history
        of actions for a given table."
      ),
      p(
        span("Further assistance can be accessed by exploring the "),
        tags$a(
          href = "https://tabulator.info/docs/5.6/history",
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
  div(
    class = "actions-container",
    style = "padding: 2rem;",
    h3("History Actions"),
    actionButton("clear_history", "Clear history"),
    actionButton("undo", "Undo"),
    actionButton("redo", "Redo")
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
      data = people_data
    ) |>
      tabulator_options(
        layout = "fitColumns",
        history = TRUE
      ) |>
      tabulator_columns(
        list(
          tabulator_column(
            field = "Name",
            title = "Name",
            editor = "input",
            editorParams = list(
              selectContents = TRUE
            )
          ),
          tabulator_column(
            title = "Date of Birth",
            field = "Date_Of_Birth",
            editor = "date"
          ),
          tabulator_column(
            field = "Progress",
            title = "Progress",
            formatter = "progress",
            sorter = "number",
            width = 150,
            editor = TRUE,
            editorParams = list(
              min = 0,
              max = 100,
              elementAttributes = list(
                title = "Slide bar to choose values"
              )
            )
          ),
          tabulator_column(
            title = "Rating",
            field = "Rating",
            hozAlign = "center",
            width = 120,
            editor = "list",
            editorParams = list(
              values = sort(unique(people_data$Rating))
            )
          ),
          tabulator_column(
            title = "Line Wraping",
            field = "line_wrapping",
            formatter = "textarea",
            editor = "textarea"
          ),
          tabulator_column(
            field = "Driver",
            title = "Is Driver",
            minWidth = 80,
            hozAlign = "center",
            formatter = "tickCross",
            editor = "tickCross"
          ),
          tabulator_column(
            field = "money",
            title = "Income",
            editor = "number"
          )
        )
      )
  })

  observeEvent(input$clear_history, {
    clear_history("table")
  })

  observeEvent(input$undo, {
    undo_action("table")
  })

  observeEvent(input$redo, {
    redo_action("table")
  })

  highlighter_server(input, output, "history")
}

shinyApp(ui, server)
