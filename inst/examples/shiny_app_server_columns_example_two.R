library(shiny)
library(tabulator)

ui <- fluidPage(
  tabulatorOutput("table"),
  highlighter_ui()
)


server <- function(input, output, session) {

  output$table <- renderTabulator({
    tabulator(people_data) |>
      column_layout_mode("fitColumns") |>
      set_layout_columns_on_new_data() |>
      pagination(pagination_size = 5, mode = "server") |>
      tabulator_columns(
        list(
          tabulator_column(
            title = "Name",
            field = "Name",
            headerFilter = TRUE,
            headerFilterFunc = "starts"
          ),
          tabulator_column(
            title = "Progress",
            field = "Progress",
            headerFilter = TRUE,
            headerFilterFunc = ">="
          ),
          tabulator_column(
            title = "Gender",
            field = "Gender",
            headerFilter = TRUE,
            headerFilterFunc = "regex"
          ),
          tabulator_column(
            title = "Rating",
            field = "Rating",
            headerFilter = TRUE,
            headerFilterFunc = "!="
          ),
          tabulator_column(
            title = "Favourite Color",
            field = "Favourite_Color",
            headerFilter = TRUE,
            headerFilterFunc = "ends"
          ),
          tabulator_column(
            title = "Date of Birth",
            field = "Date_Of_Birth",
            headerFilter = TRUE,
            headerFilterFunc = "!="
          ),
          tabulator_column(
            title = "Driver",
            field = "Driver",
            headerFilter = TRUE,
            headerFilterFunc = "!="
          )
        )
      )
  })

  highlighter_server(input, output, "columns_server_pagination_two")

}

shinyApp(ui, server)
