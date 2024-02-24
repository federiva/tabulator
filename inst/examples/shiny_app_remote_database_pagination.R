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
dbWriteTable(con, "example_data", example_data)

# Helper function to paginate results using SQL
get_paginated_data <- function(src_tbl, page, page_size = 10) {
  offset <- (page - 1) * page_size
  src_tbl |>
    paginated_select(limit = page_size, offset = offset)
}

# Define a custom handler to pass to tabulator to handle the queries that
# R will send to the DB
custom_handler <- function(data, req) {
  query_string <- parseQueryString(req$QUERY_STRING)
  page_size <- as.numeric(query_string$size)
  page <- as.numeric(query_string$page)
  db_data <- tbl(con, "example_data") |>
    filter_data(query_string = query_string) |>
    sort_data(query_string = query_string)

  paginated_data <- db_data |>
    get_paginated_data(page = page, page_size = page_size) |>
    collect()

  last_page <- get_total_pages(db_data, page_size)
  serialized_data <- jsonlite::toJSON(
    list(
      data = paginated_data,
      last_page = last_page[[1]]
    ),
    dataframe = "rows"
  )
  httpResponse(
    content_type = "application/json",
    content = serialized_data
  )
}

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
# letters_eq
# letters_in
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
        pagination_size = 15,
        mode = "remote",
        request_handler = custom_handler
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
