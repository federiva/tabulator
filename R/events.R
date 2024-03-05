# API for interacting with JS events
# https://tabulator.info/docs/5.6/events#main-contents

column_events <- list(
  "headerClick", "headerDblClick", "headerContext", "headerTap", "headerDblTap",
  "headerTapHold", "headerMouseEnter", "headerMouseLeave", "headerMouseOver"
)

is_valid_event_name <- function(event_name) {
  all(event_name %in% column_events)
}

#' @export
subscribe_events <- function(tabulator_object, events) {
  events_list <- if (length(events) == 1) list(events) else events
  tabulator_object$x$events <- events_list
  tabulator_object
}
