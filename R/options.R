default_table_options <- list(
  nestedFieldSeparator = list(
    value = ".."
  ),
  layout = list(
    value = "fitData"
  ),
  movableColumns = list(
    value = FALSE
  ),
  resizableColumnFit = list(
    value = TRUE
  ),
  history = list(
    value = FALSE
  ),
  clipboard = list(
    value = TRUE
  )
)

other_valid_options <- c("clipboardCopyConfig", "clipboard", "clipboardPasteParser")

#' Add table level options to a tabulator object
#' @param tabulator_object An object of class tabulator
#' @param ... A list of options to be added as named parameters
#' @seealso [tabulator documentation](https://tabulator.info/docs/5.6/layout)
#' @importFrom rlang list2
tabulator_options <- function(tabulator_object, ...) {
  table_options <- list2(...) |>
    test_for_valid_table_options()
  tabulator_object$x$table_options <- table_options
  tabulator_object
}

#' Checks for valid table options and returns a list of valid options
#' @param table_options A list of options to be checked
#' @importFrom cli cli_warn
test_for_valid_table_options <- function(table_options) {
  assert_is_named(table_options)
  valid_table_options_names <- c(names(default_table_options), other_valid_options)
  valid_table_options_names_default <- c(names(default_table_options))
  invalid_options <- Filter(function(x) !x %in% valid_table_options_names, names(table_options))
  valid_options <- Filter(function(x) x %in% valid_table_options_names, names(table_options))
  all_options <- unique(valid_table_options_names_default)

  if (length(invalid_options) > 0) {
    cli_warn(
      c(
        "x" = "Invalid table options: {paste(invalid_options, collapse = ', ')}",
        "i" = "Check for the valid options using {.run tabulator::get_valid_table_options()}"
      )
    )
  }
  if (length(all_options) > 0) {
    # Ensure that if default values were not provided then we use the default
    # values for these options
    default_options <- default_table_options[setdiff(all_options, valid_options)]
    if (length(default_options) > 0) {
      default_options <- lapply(default_options, function(x) x$value)
    }
    append(default_options, table_options[valid_options])
  } else {
    list()
  }
}

use_default_table_options <- function(tabulator) {
  for (default_option in names(default_table_options)) {
    if (!default_option %in% names(tabulator$x$table_options)) {
      tabulator$x$table_options[[default_option]] <- default_table_options[[default_option]]$value
    }
  }
  tabulator
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
