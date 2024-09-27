library(shiny)
library(dplyr)
library(tabulator)
library(RPostgres)
library(DBI)
library(dplyr)
library(dbplyr)


# Check for missing env vars
if (Sys.getenv("POSTGRES_USER") == "") {
  stop("Missing POSTGRES_USER env var, edit your .Renviron file")
}
if (Sys.getenv("POSTGRES_PASSWORD") == "") {
  stop("Missing POSTGRES_PASSWORD env var, edit your .Renviron file")
}
# Database connection details
dbname <- Sys.getenv("POSTGRES_DB", "tabulator_test")
host <- Sys.getenv("POSTGRES_HOST", "localhost")
port <- Sys.getenv("POSTGRES_PORT", "5432")
user <- Sys.getenv("POSTGRES_USER")
password <- Sys.getenv("POSTGRES_PASSWORD")

ui <- fluidPage(
  tabulatorOutput("table"),
  highlighter_ui()
)

server <- function(input, output, session) {
  # When the data is obtained from a remote source then the data argument
  # of the tabulator function could be empty/NULL
  con <- dbConnect(
    RPostgres::Postgres(),
    dbname = dbname,
    host = host,
    port = port,
    user = user,
    password = password
  )
  dbWriteTable(con, "example_data", people_data, overwrite = TRUE, temporary = TRUE)
  db_data <- tbl(con, "example_data") |>
    filter(
      Gender == "male"
    )

  output$table <- renderTabulator({
    tabulator() |>
      column_layout_mode("fitColumns") |>
      tabulator_columns(
        list(
          tabulator_column(
            title = "Name",
            field = "Name",
            headerFilter = TRUE,
            headerFilterFunc = "="
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
            headerFilter = FALSE
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
            headerFilterFunc = "="
          ),
          tabulator_column(
            title = "Date Of Birth",
            field = "Date_Of_Birth",
            headerFilter = TRUE,
            headerFilterFunc = "="
          ),
          tabulator_column(
            title = "Is Driver",
            field = "Driver"
          )
        )
      ) |>
      pagination(
        pagination_size = 5,
        mode = "remote",
        request_handler = default_sql_request_handler(db_data)
      ) |>
      set_layout_columns_on_new_data()
  })

  # Remove the temporary database connection once we finish
  shiny::onStop(function() {
    DBI::dbDisconnect(con)
  })

  highlighter_server(input, output, "remote_db_pagination_postgres")
}
shinyApp(ui, server)
