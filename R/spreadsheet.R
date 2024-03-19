spreadsheet <- function(tabulator_object, ...) {
  tabulator_object |>
    check_if_single_spreadsheet(...)
}

df_to_values_list <- function(df) {
  lapply(asplit(df, 1), unname)
}

check_if_single_spreadsheet <- function(tabulator_object, ...) {
  dots_opts <- list(...)
  names_opts <- names(dots_opts)
  tabulator_object$x$table_options$spreadsheet <- TRUE
  if ("data" %in% names_opts) {
    tabulator_object$x$data <- df_to_values_list(dots_opts$data)
  } else {
    if (!"spreadsheetSheets" %in% names_opts) {
      cli::cli_warn(
        c(
          "!" = "When passing the spreadsheet object you need to specify either the
          data option or the spreadsheetSheets option to specify the data you're passing
          to the spreadsheet. By default we are specifying an empty array that will
          render an empty spreadsheet"
        )
      )
      tabulator_object$x$data <- list()
    }
  }
  tabulator_object
}
