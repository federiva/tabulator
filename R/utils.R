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
#' @importFrom cli cli_alert_warning
#' @importFrom glue glue
#' @importFrom stringr str_escape
#' @noRd
check_for_valid_column_names <- function(data, nested_field_separator) {
  if (is.null(data)) {
    return(invisible())
  }
  columns <- colnames(data)
  test <- any(grepl(str_escape(nested_field_separator), columns))
  if (test) {
    invalid_columns <- grep(str_escape(nested_field_separator), columns, value = TRUE)
    cli_alert_warning(
      text = c(
        "The {invalid_columns} column{?s} will not be rendered as ",
        "this column{?s} contain characters that are the same as the `nested_field_separator`. ",
        "Please change the column names or the nestedFieldSeparator to avoid this issue.",
        "See {.fun tabulator::tabulator_options} to learn more."
      )
    )
  }
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

#' Helper function to get paginated data
#' @importFrom dbplyr sql_render
#' @importFrom dplyr select tbl everything sql
paginated_select <- function(.data, limit = 10, page = 1, ...) {
  query <- .data |>
    select(if(length(list(...)) > 0) ... else everything())
  offset <- (page - 1) * limit
  sql_query <- sql_render(query)
  custom_sql <- paste0(sql_query, " LIMIT ", limit, " OFFSET ", offset)
  tbl(.data$src$con, sql(custom_sql))
}


#' Helper function to get total number of pages
#' @importFrom  dplyr count collect pull
get_total_pages <- function(.data, page_size = 10) {
  numerator <- .data |>
    count() |>
    collect() |>
    pull(n)
  ceiling(numerator / page_size)
}


get_namespaced_id <- function(id, session = shiny::getDefaultReactiveDomain()) {
  if (!is.null(session)) {
    id <- session$ns(id)
  }
  id
}
