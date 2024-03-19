#' Run checks for the tabulator object that is being built by the user
#' @noRd
run_checks <- function(tabulator_object) {
  tabulator_object |>
    check_for_valid_nested_separator()
}

#' Checks for valid nested field separator. Checks that the column names of the
#' data frame does not contain the same characters as the nestedFieldSeparator
#' either specified by the user or the one used as default.
#' @noRd
check_for_valid_nested_separator <- function(tabulator_object) {
  if (!is_spreadsheet(tabulator_object)) {
    data <- tabulator_object$x$data
    nested_field_sep <- tabulator_object$x$table_options$nestedFieldSeparator
    check_for_valid_column_names(data = data, nested_field_separator = nested_field_sep)
  }
  tabulator_object
}
