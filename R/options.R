default_table_options <- list(
  nestedFieldSeparator = list(
    value = ".."
  )
)

tabulator_options <- function(tabulator_object, ...) {
  table_options <- rlang::list2(...) |>
    test_for_valid_table_options()
  tabulator_object$x$table_options <- table_options
  tabulator_object
}

#' @importFrom cli cli_warn
test_for_valid_table_options <- function(table_options) {
  assert_is_named(table_options)
  valid_table_options_names <- names(default_table_options)
  invalid_options <- Filter(function(x) !x %in% valid_table_options_names, names(table_options))
  valid_options <- Filter(function(x) x %in% valid_table_options_names, names(table_options))
  if (length(invalid_options) > 0) {
    cli_warn(
      c(
        "x" = "Invalid table options: {paste(invalid_options, collapse = ', ')}",
        "i" = "Check for the valid options using {.run tabulator::get_valid_table_options()}"
      )
    )
  }
  if (length(valid_options) > 0) {
    table_options[valid_options]
  } else {
    list()
  }
}

#' Gets the valid table options to be passed to a tabulator object
#' @importFrom cli cli_inform
#' @export
get_valid_table_options <- function() {
  cli_inform(
    c(
      "i" = "Valid table options are: {paste(names(default_table_options), collapse = ', ')}"
    )
  )
}

add_default_table_options <- function(tabulator_object) {
  for (default_value_name in names(default_table_options)) {
    if (!default_value_name %in% names(tabulator_object$x$table_options)) {
      tabulator_object$x$table_options[[default_value_name]] <- default_table_options[[default_value_name]]$value
    }
  }
  tabulator_object
}
