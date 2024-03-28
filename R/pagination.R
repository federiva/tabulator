pagination_modes <- c("remote", "local", "server")
endpoint_name <- "shiny-tabulator-request"

#' @importFrom checkmate assert_vector test_choice
#' @importFrom glue glue
#' @importFrom rlang abort
#' @noRd
test_for_valid_pagination_mode <- function(mode) {
  assert_vector(mode, len = 1, null.ok = TRUE, .var.name = "pagination mode")
  test <- test_choice(mode, pagination_modes, null.ok = TRUE)
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

#' Available Pagination Modes
#' Lists the available pagination modes
#' @export
get_available_pagination_modes <- function() {
  pagination_modes
}


#' Pagination
#'
#' Paginate records shown in the table
#'
#' @param tabulator_object An object of class tabulator
#' @param mode A character. Default to local. You can see the available modes
#' by calling the function `get_available_pagination_modes()`.
#' When mode is `local` tabulator will send all of the data to the frontend
#' and the data will be paginated there.
#' When mode is `server` then only the requested data will be sent from the R
#' server to the frontend thus diminishing the amount of data being serialized
#' and sent to the browser. See the example app `shiny_app_server_pagination`.
#' When mode is `remote` the `request_handler` argument must be provided and only
#' the data returned by that function will be sent to the browser. Remote should
#' be chosen when our data source is external like an API or a Database. See the
#' example app `shiny_app_remote_api_pagination.R` in order to see the
#' request_handler callback used to query an API and also the
#' `shiny_app_remote_database.R` for an example callback used in order to query
#' a database with pagination.
#' @param pagination_size A numeric. Defaults to 10, the amount of records
#' shown by each page.
#' @param pagination_initial_page TODO pass this to JS
#' @param request_handler A function with the data and req parameters that is
#' passed as the `filterFunc` argument of `session$registerDataObj`
#'
#' @seealso [tabulator documentation](https://tabulator.info/docs/5.5/page)
#'
#' @return An object of class tabulator
#'
#' @export
pagination <- function(
    tabulator_object,
    mode = "local",
    pagination_size = 10,
    pagination_initial_page = 1,
    request_handler = NULL) {
  if (test_for_valid_pagination_mode(mode)) {
    tabulator_object$x$pagination <- TRUE
    tabulator_object <- set_pagination_mode(tabulator_object, mode, request_handler)
    tabulator_object$x$ajaxURL <- get_ajax_url(mode)
    tabulator_object$x$paginationSize <- pagination_size
    tabulator_object$x$paginationInitialPage <- pagination_initial_page
  }
  tabulator_object
}


#' @noRd
filter_data_on_request <- function(request_obj, data_in) {
  query_string <- parseQueryString(request_obj$QUERY_STRING)
  if (length(query_string) == 0) {
    return()
  }
  data_in <- filter_data(data_in, query_string) |> sort_data(query_string)
  page_number <- as.numeric(query_string$page)
  page_size <- as.numeric(query_string$size)
  start_row <- (page_number - 1) * page_size + 1
  end_row <- page_number * page_size
  # Subset the dataframe based on the calculated indexes
  if (nrow(data_in) == 0) {
    data_in
  } else {
    data_in[start_row:min(end_row, nrow(data_in)), ]
  }
}


#' @noRd
get_total_pages <- function(data, page_size) {
  ceiling(nrow(data) / page_size)
}

#' @importFrom shiny getDefaultReactiveDomain
#' @noRd
get_ajax_url <- function(mode) {
  ajax_url <- NULL
  if (!is.null(mode) && mode %in% c("remote", "server")) {
    session <- getDefaultReactiveDomain()
    ajax_url <- paste0("/session/", session$token, "/dataobj/", endpoint_name)
  }
  ajax_url
}

#' @importFrom shiny parseQueryString httpResponse
#' @importFrom jsonlite toJSON
#' @noRd
default_request_handler <- function(data, req) {
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

#' @importFrom shiny getDefaultReactiveDomain
#' @noRd
set_pagination_mode <- function(tabulator_object, mode, request_handler = NULL) {
  if (is.null(request_handler)) {
    request_handler <- default_request_handler
  }

  if (!is.null(mode)) {
    if (mode %in% c("remote", "server")) {
      session <- getDefaultReactiveDomain()
      complete_dataset <- tabulator_object$x$data
      if (mode == "server") {
        # Remove data from tabulator_object to avoid rendering the data and sending
        # the complete dataframe to the frontend
        tabulator_object$x$data <- NULL
      }
      session$registerDataObj(
        name = endpoint_name,
        data = complete_dataset,
        filterFunc = request_handler
      )
      # Server mode is only meaningful for the R Package, not for the
      # JS library. Overriding to remote.
      mode <- "remote"
    }
    tabulator_object$x$paginationMode <- mode
  } else {
    mode <- "local"
  }
  tabulator_object
}

#' Default Request Handler for SQLite
#' @importFrom dplyr tbl collect
#' @importFrom jsonlite toJSON
#' @importFrom shiny httpResponse
#' @export
sqlite_request_handler <- function(tbl_db) {
  function(data, req) {
    query_string <- parseQueryString(req$QUERY_STRING)
    page_size <- as.numeric(query_string$size)
    page <- as.numeric(query_string$page)
    db_data <- tbl_db |>
      filter_data(query_string = query_string) |>
      sort_data(query_string = query_string)

    paginated_data <- db_data |>
      paginated_select(limit = page_size, page = page) |>
      collect()

    last_page <- get_total_pages(db_data, page_size)
    serialized_data <- toJSON(
      list(
        data = paginated_data,
        last_page = last_page[[1]]
      ),
      dataframe = "rows"
    )
    httpResponse(
      content_type = "application/json",
      content = serialized_data
    )
  }
}

#' @export
use_sqlite_request_handler <- function(tbl_db) {
  sqlite_request_handler(tbl_db)
}
