get_valid_app_names <- function() {
  list(
    builtin_formatters = system.file("examples", "shiny_app_builtin_formatters.R", package = "tabulator"),
    clipboard = system.file("examples", "shiny_app_clipboard.R", package = "tabulator"),
    column_definitions = system.file("examples", "shiny_app_columns.R", package = "tabulator"),
    columns_api = system.file("examples", "shiny_app_columns_api.R", package = "tabulator"),
    columns_calculations = system.file("examples", "shiny_app_columns_calculations.R", package = "tabulator"),
    columns_server_pagination_one = system.file("examples", "shiny_app_server_columns_example_one.R", package = "tabulator"),
    columns_server_pagination_two = system.file("examples", "shiny_app_server_columns_example_two.R", package = "tabulator"),
    editing = system.file("examples", "shiny_app_editing.R", package = "tabulator"),
    history = system.file("examples", "shiny_app_history.R", package = "tabulator"),
    nested_field_separator = system.file("examples", "shiny_app_options_nested_field_separator.R", package = "tabulator"),
    remote_api_pagination = system.file("examples", "shiny_app_remote_api_pagination.R", package = "tabulator"),
    remote_db_pagination = system.file("examples", "shiny_app_remote_database_pagination.R", package = "tabulator"),
    remote_db_pagination_postgres = system.file("examples", "shiny_app_remote_database_pagination_postgres.R", package = "tabulator"),
    server_pagination = system.file("examples", "shiny_app_server_pagination.R", package = "tabulator"),
    sheet = system.file("examples", "shiny_app_sheet.R", package = "tabulator"),
    table_events = system.file("examples", "shiny_app_events.R", package = "tabulator"),
    theme = system.file("examples", "shiny_app_theme.R", package = "tabulator")
  )
}

#' Run an example app
#' @importFrom shiny runApp
#' @importFrom cli cli_abort
#' @param app_name The name of the app to run
#' @param port The port to run the app on
#' @export
run_example_app <- function(app_name = NULL, port = 9999) {
  if (is.null(app_name)) {
    if (interactive()) {
      app_index <- menu(
        title = "Please select an example app to run",
        choices = names(get_valid_app_names())
      )
      app_name <- names(get_valid_app_names())[app_index]
    } else {
      cli_abort(
        c(
          "i" = "To run an example app you must pass an app name",
          "i" = "Check for the valid options using {.run tabulator::show_example_app_names()}"
        )
      )
    }
  }
  if (!app_name %in% names(get_valid_app_names())) {
    cli_abort(
      c(
        "Invalid app name: {app_name}",
        "i" = "Check for the valid options using {.run tabulator::show_example_app_names()}",
        "i" = "If you are in rstudio then you can run {.run tabulator::run_example_app()} without passing any parameter"
      )
    )
  }
  runApp(get_valid_app_names()[[app_name]], launch.browser = TRUE, port = port)
}

#' Show all valid example app names
#' @export
show_example_app_names <- function() {
  names(get_valid_app_names())
}
