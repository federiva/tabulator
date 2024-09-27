library(shiny)
library(tabulator)

ui <- fluidPage(
  div(
    class = "help-container",
    h2("About this example"),
    h3("Editing - Column Validations"),
    wellPanel(
      p(
        "This section provides sample cases that demonstrate the usage of builtin
        editors within the column definitions alongside column validations."
      ),
      p(
        span("Further assistance can be accessed by exploring the "),
        tags$a(
          href = "https://tabulator.info/docs/6.1/validate",
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
    class = "text-container",
    style = "padding: 2rem;",
    textOutput("edited_text")
  ),
  highlighter_ui()
)

# Adding more data to our sample dataset
people_data <- people_data
people_data$line_wrapping <- "Lorem ipsum dolor sit amet, elit consectetur adipisicing "
# Adding random numbers
people_data$money <- round(runif(10, 10e2, 10e4), 2)
# Adding class
people_data$class <- sample(c("A", "B", "C"), 10, replace = TRUE)


server <- function(input, output, session) {

  output$table <- renderTabulator({
    tabulator(
      data = people_data
    ) |>
      tabulator_options(
        layout = "fitColumns",
        validationMode = "highlight"
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
            field = "class",
            title = "Class",
            editor = "input",
            validator = "in:A|B|C"
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
            editor = "number",
            validator = "required"
          )
        )
      ) |>
      subscribe_events("validationFailed")
  })

  output$edited_text <- renderText({
    req(input$table_edited)
    paste(
      "Cell edited event",
      jsonlite::toJSON(
        input$table_edited,
        pretty = TRUE,
        auto_unbox = TRUE
      )
    )
  })

  observeEvent(input$table_validationFailed, {
    showNotification(
      paste(
        "Validation Failed",
        jsonlite::toJSON(input$table_validationFailed, pretty = TRUE)
      )
    )
  })

  highlighter_server(input, output, "editing")
}

shinyApp(ui, server)
