devtools::load_all()
library(shiny)
library(tabulator)

ui <- fluidPage(
  tabulatorOutput("table")
)


server <- function(input, output, session) {

    output$table <- renderTabulator({
      tabulator(iris) |>
        column_layout_mode("fitColumns") |>
        set_layout_columns_on_new_data() |>
        pagination(pagination_size = 5, mode = "server") |>
        tabulator_columns(
          list(
            tabulator_column(
              title = "Petal Length",
              field = "Petal.Length",
              headerFilter = TRUE
            ),
            tabulator_column(
              title = "Petal Width",
              field = "Petal.Width",
              headerFilter = TRUE,
              headerFilterFunc = ">="
            ),
            tabulator_column(
              title = "Sepal Length",
              field = "Sepal.Length",
              headerFilter = TRUE,
              headerFilterFunc = "<="
            ),
            tabulator_column(
              title = "Sepal Width",
              field = "Sepal.Width",
              headerFilter = TRUE,
              headerFilterFunc = "!="
            )
          )
        )
    })

}

shinyApp(ui, server)
