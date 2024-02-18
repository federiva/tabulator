rlang::on_load(
  rlang::local_use_cli()
)

#' Check for Valid Column Names in a given data.frame
#'
#' This function checks if the column names of a given data frame contain dots,
#' which are not supported by tabulator. If invalid column names are found,
#' a warning is issued with a reference to the related tabulator issue.
#'
#' @param data A data frame or tibble.
#'
#' @return NULL
#'
#' @seealso [tabulator issue](https://github.com/olifolkerd/tabulator/issues/2911)
#'
#' @importFrom cli cli_warn
#' @importFrom glue glue
#' @importFrom stringr str_escape
#' @noRd
check_for_valid_column_names <- function(data, nested_field_separator) {
  columns <- colnames(data)
  test <- any(grepl(str_escape(nested_field_separator), columns))
  if (test) {
    invalid_columns <- grep("\\.", columns, value = TRUE)
    invalid_columns_message <- glue(
      "The columns {paste(invalid_columns, collapse = ', ')} will not be rendered as ", 
      "Tabulator does not support the use of characters in the column names that are using",
      "the same string as the nested_field_separator argument"
    )
    cli_warn(
      message = c(
        invalid_columns_message,
        "!" = "The periods in the column names will be automatically converted to underscores.",
        "i" = "See {.url https://github.com/olifolkerd/tabulator/issues/2911} for reference"
      ),
      class = "WrongColumnNames"
    )
    datas <- convert_dots_to_underscores(data)
  }
  data
}

#' @importFrom stringi stri_replace_all
convert_dots_to_underscores <- function(data) {
  colnames(data) <- stri_replace_all(
    str = colnames(data),
    replacement = "_",
    regex = "\\."
  )
  data
}

#' @importFrom checkmate test_named
#' @importFrom cli cli_abort
assert_is_named <- function(x) {
  # assert with checkmate
  if (!test_named(x, type = "named")) {
    cli::cli_abort(
      message = "Input must be a named list.",
      call = NULL
    )
  }
}
