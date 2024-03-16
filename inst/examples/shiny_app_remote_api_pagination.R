library(shiny)
library(tabulator)
library(callr)

# Callback function to run the API in a background process
run_api <- function() {
  library(plumber)
  pr <- plumb(file=file.path(here::here(), "inst", "examples", "example_api.R"))
  pr$run(port=5826)
}

# RUN API in a background process
background_api <- callr::r_bg(run_api)

# Callback function to call when the Shiny session ends
close_api <- function() {
  background_api$kill()
}


ui <- fluidPage(
  tabulatorOutput("table"),
  highlighter_ui()
)

# Set the URL
api_example_url <- "http://127.0.0.1:5826/iris"

# Define a custom handler to pass to tabulator to handle the requests to the
# API to get the data
custom_handler <- function(data, req) {
  query_string <- parseQueryString(req$QUERY_STRING)
  page_size <- as.numeric(query_string$size)
  my_request <- httr2::request(api_example_url) |>
    httr2::req_url_query(page = 1, page_size = page_size) |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  httpResponse(
    content_type = "application/json",
    content = my_request[[1]]
  )
}

server <- function(input, output, session) {
# When the data is obtained from a remote source then the data argument
# of the tabulator function could be empty/NULL
    output$table <- renderTabulator({
      tabulator() |>
        column_layout_mode("fitColumns") |>
        set_layout_columns_on_new_data() |>
        pagination(
          pagination_size = 10,
          mode = "remote",
          request_handler = custom_handler
        )
    })

    shiny::onSessionEnded(close_api)

    highlighter_server(input, output, "remote_api_pagination")
}

shinyApp(ui, server)
