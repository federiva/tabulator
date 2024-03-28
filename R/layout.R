# https://tabulator.info/docs/5.5/layout#layout
column_layout_modes <- c(
  "fitData", "fitDataFill", "fitDataStretch", "fitDataTable", "fitColumns"
)

#' Available Column Layout Modes
#' @return A character The available options to set the column layout mode
#' @export
get_available_column_layout_modes <- function() {  # nolint [object_length_linter]
  column_layout_modes
}

#' Sets layout columns on new data inserted
#'
#' To keep the layout of the columns consistent, once the column widths have
#' been set on the first data load (either from the data property in the
#' constructor or the setData function) they will not be changed when new
#' data is loaded.
#' If you would prefer that the column widths adjust to the data each time you
#' load it into the table you can set the layoutColumnsOnNewData property to
#' true.
#' @param tabulator_object An object of class tabulator
#'
#' @seealso [tabulator documentation](https://tabulator.info/docs/5.5/layout#layoutcolumnsonnewdata)
#'
#' @return An object of class tabulator
#'
#' @export
set_layout_columns_on_new_data <- function(tabulator_object) {
  tabulator_object$x$layout_columns_on_new_data <- TRUE
  tabulator_object
}


#' Set the column layout mode
#'
#' You can choose how your table should layout its columns by setting the
#' layout mode.
#'
#' @param tabulator_object An object of class tabulator
#' @param mode A character
#'
#' @return An object of class tabulator
#'
#' @seealso [tabulator documentation](https://tabulator.info/docs/5.5/layout#layout)
#' @seealso `get_available_column_layout_modes()` for a list of the available
#' modes.
#'
#' @export
column_layout_mode <- function(tabulator_object, mode) {
  if (test_for_valid_mode(mode)) {
    tabulator_object$x$column_layout_mode <- mode
  }
  tabulator_object
}

#' @importFrom checkmate test_subset
#' @importFrom glue glue
#' @importFrom rlang warn
#' @noRd
test_for_valid_mode <- function(mode) {
  test <- TRUE
  if (!test_subset(mode, column_layout_modes)) {
    test <- FALSE
    message <- glue(
      "The input mode {mode} is not valid. Must be one of: ",
      "{paste(column_layout_modes, collapse = ', ')}\n",
      "See `get_available_column_layout_modes` for the available modes."
    )
    warn(
      message = message,
      class = "WrongColumnLayoutModeValue"
    )
  }
  invisible(test)
}
