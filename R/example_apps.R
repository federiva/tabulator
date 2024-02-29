get_valid_app_names <- function() {
  list(
    nested_field_separator = system.file("examples", "shiny_app_options_nested_field_separator.R", package = "tabulator"),
    remote_db_pagination = system.file("examples", "shiny_app_remote_database_pagination.R", package = "tabulator"),
    remote_api_pagination = system.file("examples", "shiny_app_remote_api_pagination.R", package = "tabulator"),
    server_pagination = system.file("examples", "shiny_app_server_pagination.R", package = "tabulator")
  )
}

#' Run an example app
#' @importFrom shiny runApp
#' @export
run_example_app <- function(app_name, port = 9999) {
  runApp(get_valid_app_names()[[app_name]], launch.browser = TRUE, port = port)
}

#' Show all valid example app names
#' @export
show_example_app_names <- function() {
  names(get_valid_app_names())
}
