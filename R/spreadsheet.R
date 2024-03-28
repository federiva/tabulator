#' Renders the table as a spreadsheet
#'
#' @param tabulator_object A tabulator object
#' @param ... Arbitrary named parameters
#' @return A tabulator object with a spreadsheet enabled
#' @export
spreadsheet <- function(tabulator_object, ...) {
  tabulator_object |>
    check_if_single_spreadsheet(...)
}


#' Create a sheet object
#'
#' @param title A character string representing the title of the sheet
#' @param key A character string representing the key of the sheet (must be unique)
#' @param ... Arbitrary named parameters
#' @return A list representing a sheet object
#' @export
sheet <- function(title, key, ...) {
  sheet_opts <- list2(...)
  if ("data" %in% names(sheet_opts)) {
    sheet_opts$data <- df_to_values_list(sheet_opts$data)
  }
  append(list(title = title, key = key), sheet_opts)
}

#' Convert a data frame to a list of values
#'
#' @param df A data frame to convert to a list of values
#' @return A list of values representing the data frame
df_to_values_list <- function(df) {
  lapply(asplit(df, 1), unname)
}

#' Check If Single Spreadsheet
#'
#' This function checks if a given `tabulator_object` should be treated as a single spreadsheet.
#' It sets the `spreadsheet` option to `TRUE` and adjusts the data based on the provided options.
#' If `data` is specified in the options, it is converted and assigned to the `tabulator_object`.
#' If `data` is not provided but `spreadsheetSheets` is not specified either, a warning is issued,
#' and an empty spreadsheet is initialized. Any additional options are appended to the `table_options`.
#'
#' @param tabulator_object The tabulator object to be modified.
#' @param ... Additional options to be considered for the spreadsheet.
#'              - `data`: A dataframe to be used as the spreadsheet data.
#'              - `spreadsheetSheets`: Sheets to be included in the spreadsheet if `data` is not provided.
#' @return Modified tabulator object with the spreadsheet options adjusted.
#' @importFrom cli cli_warn
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
  if (length(dots_opts) > 0) {
    tabulator_object$x$table_options <- append(tabulator_object$x$table_options, dots_opts)
  }
  tabulator_object
}


#' Enable copy paste for a spreadsheet
#'
#' @param tabulator_object A tabulator object
#' @return The modified tabulator object
#' @export
enable_copy_paste <- function(tabulator_object) {
  copy_opts <- list(
    clipboard = TRUE,
    clipboardCopyStyled = FALSE,
    clipboardCopyConfig = list(
        rowHeaders = FALSE,
        columnHeaders = FALSE
    ),
    clipboardCopyRowRange = "range",
    clipboardPasteParser = "range",
    clipboardPasteAction = "range"
  )

  tabulator_object$x$table_options <- append(tabulator_object$x$table_options, copy_opts)
  tabulator_object
}


#' Enable range selection for a spreadsheet
#'
#' This function enables range selection for a spreadsheet.
#' Range selection allows users to select a range of cells and
#' perform operations on multiple cells at once.
#'
#' @param tabulator_object A tabulator object
#' @return The modified tabulator object
#' @export
enable_range_selection <- function(tabulator_object) {

  range_opts <- list(
    selectableRange = 1,
    selectableRangeClearCells = TRUE,
    selectableRangeColumns = TRUE,
    selectableRangeRows = TRUE,
    spreadsheetSheetTabs = TRUE
  )

  tabulator_object$x$table_options <- append(tabulator_object$x$table_options, range_opts)
  tabulator_object
}

#' Clear a sheet from a spreadsheet
#' This function clears a sheet from a spreadsheet.
#'
#' @param table_id The ID of the table
#'
#' @param session The session to send the custom message to. Defaults to the default shiny session.
#' @param key The key of the sheet to clear
#' @return NULL
#' @export
clear_sheet <- function(table_id, key, session = shiny::getDefaultReactiveDomain()) {
  session$sendCustomMessage(
    type = "clear_sheet",
    message = list(
      table_id = get_namespaced_id(table_id, session),
      key = key
    )
  )
}

add_sheet <- function(table_id, title, key, session = shiny::getDefaultReactiveDomain(), ...) {
  sheet_definition <- sheet(title, key, ...)
  session$sendCustomMessage(
    type = "add_sheet",
    message = list(
      table_id = get_namespaced_id(table_id, session),
      sheet = sheet_definition
    )
  )
}
