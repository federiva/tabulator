library(shiny)
library(tabulator)

ui <- fluidPage(
  div(
    class = "help-container",
    h2("About this example"),
    h3("Columns Calculations"),
    wellPanel(
      p(
        "This section provides sample cases that demonstrate the usage of builtin
        column calculations."
      ),
      p(
        span("Further assistance can be accessed by exploring the "),
        tags$a(
          href = "https://tabulator.info/docs/6.0/column-calcs",
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

# Adding random numbers
people_data$money <- round(runif(10, 10e2, 10e4), 2)


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
            field = "Name",
            title = "Name",
            minWidth = 200,
            maxWidth = 300
          ),
          tabulator_column(
            field = "money",
            title = "Income",
            bottomCalc = "sum"
          ),
          tabulator_column(
            field = "Driver",
            title = "Driver",
            bottomCalc = "count",
            formatter = "tickCross",
            editor = "tickCross"
          ),
          tabulator_column(
            field = "Progress",
            title = "Progress",
            formatter = "progress",
            sorter = "number",
            width = 150,
            resizable = FALSE,
            botomCalc = "avg",
            bottomCalcParams = list(
              precision = 2
            )
          ),
          tabulator_column(
            title = "Rating",
            field = "Rating",
            hozAlign = "center",
            width = 120,
            topCalc = "avg"
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
          )

        )
      )
  })
  highlighter_server(input, output, app_name = "columns_calculations")
}

shinyApp(ui, server)
