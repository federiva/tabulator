#' Hide a column by field name
#' @param table_id The ID of the table
#' @param field The field to be shown
#' @param session The Shiny session
#' @export
hide_column_by_field <- function(table_id, field, session = shiny::getDefaultReactiveDomain()) {
  session$sendCustomMessage(
    type = "hide_column_by_field",
    message = list(
      table_id = table_id,
      field = field
    )
  )
}

#' Show a column by field name
#' @param table_id The ID of the table
#' @param field The field to be shown
#' @param session The Shiny session
#' @export
show_column_by_field  <- function(table_id, field, session = shiny::getDefaultReactiveDomain()) {
  session$sendCustomMessage(
    type = "show_column_by_field",
    message = list(
      table_id = table_id,
      field = field
    )
  )
}

#' Toggle a column by field name
#' @param table_id The ID of the table
#' @param field The field to be shown
#' @param session The Shiny session
#' @export
toggle_column_by_field  <- function(table_id, field, session = shiny::getDefaultReactiveDomain()) {
  session$sendCustomMessage(
    type = "toggle_column_by_field",
    message = list(
      table_id = table_id,
      field = field
    )
  )
}
