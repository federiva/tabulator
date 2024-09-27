#' Hide a column by field name
#' @param table_id The ID of the table
#' @param field The field to be shown
#' @param session The Shiny session
#' @export
hide_column_by_field <- function(table_id, field, session = shiny::getDefaultReactiveDomain()) {
  if (!is.null(session)) {
    table_id <- session$ns(table_id)
  }
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
show_column_by_field <- function(table_id, field, session = shiny::getDefaultReactiveDomain()) {
  if (!is.null(session)) {
    table_id <- session$ns(table_id)
  }
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
toggle_column_by_field <- function(table_id, field, session = shiny::getDefaultReactiveDomain()) {
  if (!is.null(session)) {
    table_id <- session$ns(table_id)
  }
  session$sendCustomMessage(
    type = "toggle_column_by_field",
    message = list(
      table_id = table_id,
      field = field
    )
  )
}

#' Replace column definitions
#' @param table_id The ID of the table
#' @param columns The column definitions
#' @param session The Shiny session
#' @export
replace_column_definitions <- function(table_id, columns, session = shiny::getDefaultReactiveDomain()) {
  if (!is.null(session)) {
    table_id <- session$ns(table_id)
  }
  session$sendCustomMessage(
    type = "replace_column_definitions",
    message = list(
      table_id = table_id,
      columns = columns
    )
  )
}

#' Update column definition
#' @param table_id The ID of the table
#' @param field The field to be updated
#' @param column_definition The column definition. The output of the
#' `tabulator_column` function
#' @param session The Shiny session
#' @export
update_column_definition <- function(table_id, field, column_definition, session = shiny::getDefaultReactiveDomain()) {
  if (!is.null(session)) {
    table_id <- session$ns(table_id)
  }
  session$sendCustomMessage(
    type = "update_column_definition",
    message = list(
      table_id = table_id,
      field = field,
      column_definition = column_definition
    )
  )
}

#' Add a column definition
#' @param table_id The ID of the table
#' @param column_definition The column definition. The output of the
#' `tabulator_column` function
#' @param before Whether the column should be added before or after
#' @param position The position of the column
#' @param session The Shiny session
#' @export
add_column <- function(
    table_id,
    column_definition,
    before = FALSE,
    position = NULL,
    session = shiny::getDefaultReactiveDomain()) {
  if (!is.null(session)) {
    table_id <- session$ns(table_id)
  }
  session$sendCustomMessage(
    type = "add_column",
    message = list(
      table_id = table_id,
      column_definition = column_definition,
      before = before,
      position = position
    )
  )
}

#' Delete a column
#' @param table_id The ID of the table
#' @param field The field to be deleted
#' @param session The Shiny session
#' @export
delete_column <- function(table_id, field, session = shiny::getDefaultReactiveDomain()) {
  if (!is.null(session)) {
    table_id <- session$ns(table_id)
  }
  session$sendCustomMessage(
    type = "delete_column",
    message = list(
      table_id = table_id,
      field = field
    )
  )
}
