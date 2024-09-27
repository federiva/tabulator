copy_table_valid_what_options <- c("active", "all", "selected", "visible")
#' Copy the table to the clipboard
#' @param table_id The ID of the table
#' @param what Which rows to copy. Available options are
#' "active", "all", "selected", "visible"
#' @param session The Shiny session object
#' @importFrom shiny getDefaultReactiveDomain
#' @importFrom cli cli_warn
#' @export
copy_table <- function(table_id, what = "all", session = shiny::getDefaultReactiveDomain()) {
  if (!what %in% copy_table_valid_what_options) {
    what <- "all"
    cli_warn(
      c(
        "x" = "Invalid `what` option. Using `all` instead.",
        "i" = "Valid options are {paste(copy_table_valid_what_options, collapse = ', ')}"
      )
    )
  }
  session$sendCustomMessage(
    type = "copy_table",
    message = list(
      table_id = get_namespaced_id(table_id, session),
      what = what
    )
  )
}
