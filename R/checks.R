run_checks <- function(tabulator_object) {
  tabulator_object |>
    check_for_valid_nested_separator()
}

check_for_valid_nested_separator <- function(tabulator_object) {
  data <- tabulator_object$x$data
  nested_field_sep <- tabulator_object$x$table_options$nestedFieldSeparator
  check_for_valid_column_names(data = data, nested_field_separator = nested_field_sep)
  tabulator_object
}
