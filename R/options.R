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

#' Add table level options to a tabulator object
#' @param tabulator_object An object of class tabulator
#' @param ... A list of options to be added as named parameters
#' @seealso [tabulator documentation](https://tabulator.info/docs/6.0/layout)
#' @importFrom rlang list2
tabulator_options <- function(tabulator_object, ...) {
  table_options <- list2(...)
  tabulator_object$x$table_options <- table_options
  tabulator_object
}

#' Use default table options if they are not provided
#'
#' @param tabulator_object A tabulator object
#' @return The same tabulator object but with default options added if they
#' were not provided
use_default_table_options <- function(tabulator_object) {
  if (!is_spreadsheet(tabulator_object)) {
    for (default_option in names(default_table_options)) {
      if (!default_option %in% names(tabulator_object$x$table_options)) {
        tabulator_object$x$table_options[[default_option]] <- default_table_options[[default_option]]$value
      }
    }
  }
  tabulator_object
}
