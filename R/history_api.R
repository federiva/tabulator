#' Undo an action for the given table
#' @param table_id The ID of the table
#' @param session The Shiny session object
#' @importFrom shiny getDefaultReactiveDomain
#' @export
undo_action <- function(table_id, session = shiny::getDefaultReactiveDomain()) {
  session$sendCustomMessage(
    type = "undo_action",
    message = list(table_id = get_namespaced_id(table_id, session))
  )
}

#' Redo an action for the given table
#' @param table_id The ID of the table
#' @param session The Shiny session object
#' @importFrom shiny getDefaultReactiveDomain
#' @export
redo_action <- function(table_id, session = shiny::getDefaultReactiveDomain()) {
  session$sendCustomMessage(
    type = "redo_action",
    message = list(table_id = get_namespaced_id(table_id, session))
  )
}

#' Clear history for the given table
#' @param table_id The ID of the table
#' @param session The Shiny session object
#' @importFrom shiny getDefaultReactiveDomain
#' @export
clear_history <- function(table_id, session = shiny::getDefaultReactiveDomain()) {
  session$sendCustomMessage(
    type = "clear_history",
    message = list(table_id = get_namespaced_id(table_id, session))
  )
}
