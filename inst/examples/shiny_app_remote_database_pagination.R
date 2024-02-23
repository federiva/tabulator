devtools::load_all()
library(shiny)
library(dplyr)
library(tabulator)
library(RSQLite)
library(dplyr)
library(dbplyr)


# TODO Feb 19
# 1. Implement header filters
# 2. Implement header sorters
# 3. Calculate last page dynamically. Add feature to calculate the last page
# when some filtering is added to the data. For example, when we are using
# header filters for a given column then it may occur that the amount of data
# returned is less pages than the

temp_sqlite_path <- file.path(tempdir(), "iris.sqlite")
# Create DB
con <- dbConnect(SQLite(), dbname = temp_sqlite_path)
dbWriteTable(con, "iris", iris)

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
  print(query_string)
  page_size <- as.numeric(query_string$size)
  page <- as.numeric(query_string$page)
  db_data <- tbl(con, "iris") |>
    get_paginated_data(page = page, page_size = page_size) |>
    collect()
  last_page <- get_total_pages(tbl(con, "iris"), page_size)
  serialized_data <- jsonlite::toJSON(
    list(
      data = db_data,
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
          tabulator_column(
            title = "Petal Length",
            field = "Petal.Length",
            headerFilter = TRUE
          ),
          tabulator_column(
            title = "Sepal Length",
            field = "Sepal.Length",
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
