devtools::load_all()
library(shiny)
library(tabulator)
library(RSQLite)

temp_sqlite_path <- file.path(tempdir(), "iris.sqlite")
# Create DB
con <- dbConnect(SQLite(), dbname = temp_sqlite_path)
dbWriteTable(con, "iris", iris)

# Helper function to paginate results using SQL
get_paginated_data <- function(page, page_size = 10) {
  offset <- (page - 1) * page_size
  query <- sprintf("SELECT * FROM iris LIMIT %d OFFSET %d", page_size, offset)
  dbGetQuery(con, query)
}

paginated_select <- function(.data, limit = 10, offset = 5, ...) {
  query <- .data |>
    select(...)
  # Convert the query to SQL
  sql_query <- sql_render(query)
  custom_sql <- paste0(sql_query, " LIMIT ", limit, " OFFSET ", offset)
  # Use `tbl` with the custom SQL to create a new lazy query
  tbl(.data$src$con, sql(custom_sql))
}

tbl(con, "iris") |>
  paginated_select("Sepal.Length", "Petal.Length", limit = 5, offset = 0)

# Define a custom handler to pass to tabulator to handle the queries that
# R will send to the DB
custom_handler <- function(data, req) {
  query_string <- parseQueryString(req$QUERY_STRING)
  page_size <- as.numeric(query_string$size)
  page <- as.numeric(query_string$page)
  db_data <- get_paginated_data(page, page_size)
  last_page <- ceiling(dbGetQuery(con, "SELECT COUNT() as count FROM iris") / page_size)
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
      set_layout_columns_on_new_data() |>
      pagination(
        pagination_size = 15,
        mode = "remote",
        request_handler = custom_handler
      )
  })

  # Remove the temporary database once we finish
  shiny::onStop(function() {
    unlink(temp_sqlite_path, force = TRUE)
  })

}
shinyApp(ui, server)
