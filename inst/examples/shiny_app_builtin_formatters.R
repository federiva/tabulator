devtools::load_all()
library(shiny)
library(tabulator)

ui <- fluidPage(
  tabulatorOutput(outputId = "table")
)

people_data$line_wrapping <- "Lorem ipsum dolor sit amet, elit consectetur adipisicing "
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
            formatter = "rownum",
            hozAlign = "center",
            headerSort = FALSE,
            width = 50
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
            formatter = "buttonCross",
            width = 30,
            hozAlign = "center"
          ),
          tabulator_column(
            field = "money",
            formatter = "money",
            formatterParams = list(
              symbol = "AR$ ",
              decimal = ",",
              thousand = "."
            ),
            width = 200,
            hozAlign = "center"
          )
        )
      )
  })
}

shinyApp(ui, server)
