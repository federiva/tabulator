library(shiny)
library(tabulator)


example_data <- data.frame(
  numbers_eq = c(1:10),
  numbers_gt = c(1:10),
  numbers_lt = c(1:10),
  numbers_ne = c(1:10),
  numbers_gte = c(1:10),
  numbers_lte = c(1:10),
  letters_eq = letters[1:10],
  letters_in = c("abc", "def", "ghi", "jkl", "mnñ", "opq", "rst", "uvw", "xyz", "abc"),
  letters_regex = c("abc", "def", "ghi", "jkl", "mnñ", "opq", "rst", "uvw", "xyz", "abc"),
  letters_ends = c("abc", "def", "ghi", "jkl", "mnñ", "opq", "rst", "uvw", "xyz", "abc"),
  letters_starts = c("abc", "def", "ghi", "jkl", "mnñ", "opq", "rst", "uvw", "xyz", "abc")
)

events_list <- unlist(get_valid_event_names(), use.names = FALSE)

ui <- fluidPage(
  div(
    class = "help-container",
    h2("About this example"),
    h3("Events"),
    wellPanel(
      p(
        "This section provides sample cases that demonstrate the usage of events
        in tabulator."
      ),
      p(
        span("Further assistance can be accessed by exploring the "),
        tags$a(
          href = "https://tabulator.info/docs/5.6/events",
          target = "_blank",
          "Tabulator's documentation."
        )
      )
    )
  ),
  tabulatorOutput("table"),
  div(
    class = "columns-actions-container",
    style = "margin-top: 1rem;",
    actionButton("toggle_letters_eq", "Toggle let = column"),
    div(
      class = "events-container",
      selectInput(
        inputId = "event",
        label = "Select an event",
        choices = events_list
      ),
      h4("Events Output"),
      textOutput("table_events")
    )
  ),
  highlighter_ui()
)

server <- function(input, output, session) {

    # Latest event reactive Value
    latest_event <- reactiveVal()

    observeEvent(input$toggle_letters_eq, {
      toggle_column_by_field(
        table_id = "table",
        field = "letters_eq",
        session = session
      )
    })

    # Subscribe to events
    output$table <- renderTabulator({
      tabulator(example_data) |>
        tabulator_options(
          movableColumns = TRUE
        ) |>
        tabulator_columns(
          list(
            tabulator_column(
              title = "let =",
              field = "letters_eq"
            ),
            tabulator_column(
              title = "let in",
              field = "letters_in"
            ),
            tabulator_column(
              title = "eq =",
              field = "numbers_eq"
            ),
            tabulator_column(
              title = "neq !=",
              field = "numbers_ne"
            ),
            tabulator_column(
              title = "gt >",
              field = "numbers_gt"
            ),
            tabulator_column(
              title = "gte >=",
              field = "numbers_gte"
            ),
            tabulator_column(
              title = "lt <",
              field = "numbers_lt"
            ),
            tabulator_column(
              title = "lte <=",
              field = "numbers_lte"
            ),
            tabulator_column(
              title = "regex",
              field = "letters_regex"
            ),
            tabulator_column(
              title = "ends",
              field = "letters_ends"
            ),
            tabulator_column(
              title = "starts",
              field = "letters_starts"
            )
          )
        ) |>
        subscribe_events(input$event)
    })

    # Adding observers for each one of the events
    purrr::map(events_list, function(event) {
      input_name <- sprintf("table_%s", event)
      observeEvent(input[[input_name]], {
        latest_event(input[[input_name]])
      })
    })

    # Display the latest event data in the UI
    output$table_events <- renderText({
      jsonlite::toJSON(latest_event())
    })

    highlighter_server(input, output, "table_events")
}

shinyApp(ui, server)
