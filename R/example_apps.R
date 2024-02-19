valid_app_names <- list(
  nested_field_separator = system.file("examples", "shiny_app_options_nested_field_separator.R", package = "tabulator")
)

#' Run an example app
#' @importFrom shiny runApp
#' @export
run_example_app <- function(app_name) {
  runApp(valid_app_names[[app_name]], launch.browser = TRUE)
}

#' Show all valid example app names
#' @export
show_example_app_names <- function() {
  names(valid_app_names)
}
