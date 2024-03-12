library(shiny)
library(tabulator)

ui <- fluidPage(
  div(
    class = "help-container",
    h2("About this example"),
    h3("Column Formatters - Custom Callbacks"),
    wellPanel(
      p(
        "This section provides sample cases that demonstrate the usage of column
        formatters, integration of custom callbacks and the rendering of shiny widgets
        into the cells."
      ),
      p(
        span("For a detailed guide on the formatters at your disposal, utilize the "),
        span(tags$code("get_builtin_formatters()")),
        span("helper function.")
      ),
      p(
        span("Further assistance can be accessed by exploring the "),
        tags$a(
          href = "https://tabulator.info/docs/5.6/format#format-builtin",
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
# Adding URLs
people_data$url <- paste(
  sprintf(
    "https://en.wikipedia.org/w/index.php?search=%s",
    htmltools::urlEncodePath(people_data$Name)
  )
)
# Adding actionButtons
people_data$shiny <- unlist(
  lapply(
    1:10, function(x) as.character(actionButton(sprintf("click_%s", x), "Click me"))
  )
)


server <- function(input, output, session) {

  output$table <- renderTabulator({
    tabulator(
      data = people_data
    ) |>
      tabulator_options(
        layout = "fitColumns"
      ) |>
      tabulator_columns(
        list(
          tabulator_column(
            formatter = "rownum",
            hozAlign = "center",
            headerSort = FALSE,
            width = 50
          ),
          tabulator_column(
            field = "url",
            formatter = "link",
            title = "Name",
            formatterParams = list(
              target = "_blank",
              lafelField = "Name",
              label = htmlwidgets::JS(
                "function(cell) {
                  const name = cell.getData().Name
                  return name
                }"
              )
            )
          ),
          tabulator_column(
            field = "Progress",
            title = "Progress",
            formatter = "progress",
            sorter = "number",
            headerSortStartingDir = "desc",
            width = 200
          ),
          tabulator_column(
            title = "Rating",
            field = "Rating",
            formatter = "star",
            formatterParams = list(
              stars = 6
            ),
            hozAlign = "center",
            width = 120
          ),
          tabulator_column(
            title = "Driver",
            field = "Driver",
            hozAlign = "center",
            formatter = "tickCross",
            sorter = "boolean",
            width = 75
          ),
          tabulator_column(
            title = "Color",
            field = "Favourite_Color",
            formatter = "color",
            width = 75
          ),
          tabulator_column(
            title = "Line Wraping",
            field = "line_wrapping",
            formatter = "textarea"
          ),
          tabulator_column(
            formatter = "buttonTick",
            width = 30,
            hozAlign = "center"
          ),
          tabulator_column(
            field = "money",
            title = "Income",
            formatter = "money",
            formatterParams = list(
              symbol = "AR$ ",
              decimal = ",",
              thousand = "."
            ),
            width = 200,
            hozAlign = "center"
          ),
          tabulator_column(
            title = "Shiny",
            field = "shiny",
            formatter = "html"
          )
        )
      )
  })

  # Iterating over the ids we added to the data to observe them changing
  lapply(paste("click", 1:10, sep = "_"), function(input_id) {
    observeEvent(input[[input_id]], {
      showNotification(paste("Hi from", input_id))
    })
  })

  highlighter_server(input, output, "builtin_formatters")

}

shinyApp(ui, server)
