# API for interacting with JS events
# https://tabulator.info/docs/6.0/events#main-contents

event_names <- list(
  column_events = c(
    "headerClick", "headerDblClick", "headerContext", "headerTap", "headerDblTap",
    "headerTapHold", "headerMouseEnter", "headerMouseLeave", "headerMouseOver",
    "headerMouseOut", "headerMouseMove", "headerMouseDown", "headerMouseUp",
    "columnMoved", "columnResized", "columnTitleChanged", "columnVisibilityChanged"
  ),
  row_events = c(
    "rowClick", "rowDblClick", "rowContext", "rowTap", "rowDblTap", "rowTapHold",
    "rowMouseEnter", "rowMouseLeave", "rowMouseOver", "rowMouseOut", "rowMouseMove",
    "rowMouseDown", "rowMouseUp", "rowAdded", "rowUpdated", "rowDeleted", "rowResized"
  ),
  cell_events = c(
    "cellClick", "cellDblClick", "cellContext", "cellTap", "cellDblTap", "cellTapHold",
    "cellMouseEnter", "cellMouseLeave", "cellMouseOver", "cellMouseOut", "cellMouseMove",
    "cellMouseDown", "cellMouseUp"
  )
)


#' Checks for valid event names and returns a list of valid event names
#' @param event_name A list of event names to be checked
#' @return List of valid event names
check_valid_event_name <- function(event_name) {
  all_events <- unlist(event_names, use.names = FALSE)
  test <- all(event_name %in% all_events)
  if (!test) {
    #list events that are not valid
    invalid_events <- setdiff(event_name, all_events)
    cli_warn(
      c(
        "x" = "Invalid event names: {paste(invalid_events, collapse = ', ')}",
        "i" = "Check for the valid options using {.run tabulator::get_valid_event_names()}"
      )
    )
  }
  intersect(event_name, all_events)
}


#' Gets the valid event names to be passed to a tabulator object
#' @return List of valid event names
#' @export
get_valid_event_names <- function() {
  event_names
}

#' Subscribe events for the current table
#' Once events are subscribed, the events triggered in the browser can be listened
#' via registered inputs following the pattern `input$<table_id>_<eventName>`. For example
#' if the `cellClick` event was subscribed for a table with an id `my_table` then
#' you can use it in your Shiny app via the input registered to `input$table_cellClick`
#' Also you can run `run_example_app("table_events")` to see all the events available.
#' @param tabulator_object A tabulator object
#' @param events List of events to subscribe. Also can be a single character
#' @export
subscribe_events <- function(tabulator_object, events) {
  events_list <- if (length(events) == 1) list(events) else events
  events_list <- check_valid_event_name(events_list)
  if (length(events_list) > 0) {
    tabulator_object$x$events <- c(tabulator_object$x$events, events_list)
  }
  tabulator_object
}
