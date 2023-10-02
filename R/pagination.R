pagination_modes <- c("remote", "local")
endpoint_name <- "shiny-tabulator-request"

#  pagination:true, //enable pagination
#     paginationMode:"remote", //enable remote pagination
#     ajaxURL:"http://testdata.com/data", //set url for ajax request
#     ajaxParams:{token:"ABC123"}, //set any standard parameters to pass with the request
#     paginationSize:5, //optional parameter to request a certain number of rows per page
#     paginationInitialPage:2, //
# https://tabulator.info/docs/5.5/page
#' @importFrom checkmate assert_vector test_choice
#' @importFrom glue glue
#' @importFrom rlang abort
test_for_valid_pagination_mode <- function(mode) {
  assert_vector(mode, len = 1, null.ok = TRUE, .var.name = "pagination mode")
  test <- test_choice(mode, pagination_modes)
  if (!test) {
    message <- glue(
      "Pagination mode {mode} should be one of the available pagination modes. Check ",
      "the available pagination modes using the `get_available_pagination_modes()` ",
      "function.\n",
    )
    abort(
      message = message,
      class = "WrongPaginationModeValue"
    )
  }
  invisible(TRUE)
}

#' Lists the available pagination modes
#' @export
get_available_pagination_modes <- function() {
  pagination_modes
}

#' @export
pagination <- function(tabulator_object, mode = NULL, ajax_url = NULL, ajax_params = NULL, pagination_size = 10, pagination_initial_page = 1) {
  if (test_for_valid_pagination_mode(mode)) {
    tabulator_object$x$pagination <- TRUE
    tabulator_object <- get_pagination_mode(tabulator_object, mode)
    tabulator_object$x$ajaxURL <- get_ajax_url(mode, ajax_url)
    tabulator_object$x$ajaxParams <- ajax_params
    tabulator_object$x$paginationSize <- pagination_size
    tabulator_object$x$paginationInitialPage <- pagination_initial_page
  }
  tabulator_object
}

#' @export
filter_data_on_request <- function(request_obj, data_in) {
  query_string <- parseQueryString(request_obj$QUERY_STRING)
  if (length(query_string) == 0) {
    return()
  }
  page_number <- as.numeric(query_string$page)
  page_size <- as.numeric(query_string$size)
  start_row <- (page_number - 1) * page_size + 1
  end_row <- page_number * page_size
  # Subset the dataframe based on the calculated indices
  data_in[start_row:min(end_row, nrow(data_in)), ]
}

#' @export
get_total_pages <- function(data, page_size) {
  ceiling(nrow(data) / page_size)
}

#' @importFrom shiny getDefaultReactiveDomain
get_ajax_url <- function(mode, ajax_url) {
  if (mode == "remote") {
    if (is.null(ajax_url)) {
      session <- getDefaultReactiveDomain()
      ajax_url <- paste0("/session/", session$token, "/dataobj/", endpoint_name)
    }
  }
  ajax_url
}


#' @importFrom shiny getDefaultReactiveDomain parseQueryString
#' @importFrom jsonlite toJSON
get_pagination_mode <- function(tabulator_object, mode) {
  if (mode == "remote") {
    tabulator_object$x$paginationMode <- mode
    session <- getDefaultReactiveDomain()
    complete_dataset <- tabulator_object$x$data
    # Remove data from tabulator_object to avoid rendering the data and sending
    # the complete dataframe to the frontend
    tabulator_object$x$data <- NULL
    
    session$registerDataObj(
      name = endpoint_name,
      data = complete_dataset,
      filterFunc = function(data, req) {
        query_string <- parseQueryString(req$QUERY_STRING)
        if (length(query_string) == 0) {
          return()
        }
        page_size <- as.numeric(query_string$size)
        data <- list(
          data = filter_data_on_request(req, data),
          last_page = get_total_pages(data, page_size)
        )
        httpResponse(
          content_type = "application/json",
          content = toJSON(data, dataframe = "rows")
        )
      }
    )
  }
  tabulator_object
}
