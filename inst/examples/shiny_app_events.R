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

events_list <- c(
  "headerClick", "headerDblClick", "headerContext", "headerTap", "headerDblTap",
  "headerTapHold", "headerMouseEnter", "headerMouseLeave", "headerMouseOver",
  "headerMouseOut", "headerMouseMove", "headerMouseDown", "headerMouseUp"
)

ui <- fluidPage(
  tabulatorOutput("table"),
  selectInput(
    inputId = "event",
    label = "Select an event",
    choices = events_list
  ),
  div(
    class = "events-container",
    h4("Events Output"),
    textOutput("table_events")
  )
)

server <- function(input, output, session) {

    # Latest event reactive Value
    latest_event <- reactiveVal()

    # Subscribe to events
    output$table <- renderTabulator({
      tabulator(example_data) |>
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

}

shinyApp(ui, server)
