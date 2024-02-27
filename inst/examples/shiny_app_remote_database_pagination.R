devtools::load_all()
library(shiny)
library(dplyr)
library(tabulator)
library(RSQLite)
library(dplyr)
library(dbplyr)

example_data <- data.frame(
  numbers_eq = c(1:10),
  numbers_gt = c(1:10),
  numbers_lt = c(1:10),
  numbers_ne = c(1:10),
  numbers_gte = c(1:10),
  numbers_lte = c(1:10),
  letters_eq = letters[1:10],
  letters_in = letters[1:10]
)

temp_sqlite_path <- file.path(tempdir(), "example_data")
# Create DB
con <- dbConnect(SQLite(), dbname = temp_sqlite_path)
dbWriteTable(con, "example_data", example_data, overwrite = TRUE)
db_data <- tbl(con, "example_data")

ui <- fluidPage(
  tabulatorOutput("table")
)

server <- function(input, output, session) {
  # When the data is obtained from a remote source then the data argument
  # of the tabulator function could be empty/NULL
  output$table <- renderTabulator({
    tabulator() |>
      column_layout_mode("fitColumns") |>
      tabulator_columns(
        list(
          tabulator_column(
            title = "let =",
            field = "letters_eq",
            headerFilter = TRUE,
            headerFilterFunc = "="
          ),
          tabulator_column(
            title = "let in",
            field = "letters_in",
            headerFilter = TRUE,
            headerFilterFunc = "in"
          ),
          tabulator_column(
            title = "eq =",
            field = "numbers_eq",
            headerFilter = TRUE,
            headerFilterFunc = "="
          ),
          tabulator_column(
            title = "neq !=",
            field = "numbers_ne",
            headerFilter = TRUE,
            headerFilterFunc = "!="
          ),
          tabulator_column(
            title = "gt >",
            field = "numbers_gt",
            headerFilter = TRUE,
            headerFilterFunc = ">"
          ),
          tabulator_column(
            title = "gte >=",
            field = "numbers_gte",
            headerFilter = TRUE,
            headerFilterFunc = ">="
          ),
          tabulator_column(
            title = "lt <",
            field = "numbers_lt",
            headerFilter = TRUE,
            headerFilterFunc = "<"
          ),
          tabulator_column(
            title = "lte <=",
            field = "numbers_lte",
            headerFilter = TRUE,
            headerFilterFunc = "<="
          )
        )
      ) |>
      pagination(
        pagination_size = 5,
        mode = "remote",
        request_handler = use_sqlite_request_handler(db_data)
      ) |>
      set_layout_columns_on_new_data()
  })

  # Remove the temporary database once we finish
  shiny::onStop(function() {
    DBI::dbDisconnect(con)
    unlink(temp_sqlite_path, force = TRUE)
  })

}
shinyApp(ui, server)
