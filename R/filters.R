available_symbol_operators <- list(
  `=` = "==",
  `!=` = "!=",
  `<` = "<",
  `>` = ">",
  `<=` = "<=",
  `>=` = ">=",
  `in` = "%in%"
)


#' @importFrom glue glue
#' @noRd
parse_filters_from_query_string <- function(query_string) {
  filter_names <- grep(
    pattern = "^filter\\[\\d+\\]\\[[a-zA-Z]+\\]$",
    x = names(query_string),
    value = TRUE
  )
  parsed_filters <- list()
  if (length(filter_names) > 0) {
    filter_indexes <- extract_unique_numbers_from_query_string(filter_names)
    seq <- 1
    for (filter_index in filter_indexes) {
      field_name <- glue("filter[{filter_index}][field]")
      type_name <- glue("filter[{filter_index}][type]")
      value_name <- glue("filter[{filter_index}][value]")
      parsed_filters[[seq]] <- list(
        field = query_string[[field_name]],
        value = query_string[[value_name]],
        type = query_string[[type_name]]
      )
      seq <- seq + 1
    }
  }
  parsed_filters
}

#' @importFrom stringr str_extract
extract_unique_numbers_from_query_string <- function(query_string_names) {
  str_extract(query_string_names, "(?<=\\[)\\d+(?=\\])") |>
    unique() |>
    as.numeric()
}


#' @importFrom stringr str_detect str_starts str_ends
#' @importFrom rlang sym warn
#' @importFrom glue glue
#' @importFrom dplyr filter
#' @noRd
run_filter_func <- function(data_in, type, field, value) {
  # TODO Fede Oct 15 / Extract the logic of callback functions to a similar logic applied in dynamic_symbol_filter
  tryCatch({
    # Parse pattern to allow modified patterns when working with dbplyr
    # See https://www.tidyverse.org/blog/2023/10/dbplyr-2-4-0/#new-translations
    pattern <- parse_pattern(data_in, type, value)
    if (type == "like") {
      data_in |>
        filter(str_detect(string = !!sym(field), pattern = pattern))
    } else if (type == "ends") {
      data_in |>
        filter(str_ends(string = !!sym(field), pattern = pattern))
    } else if (type == "regex") {
      data_in |>
        filter(grepl(x = !!sym(field), pattern = pattern))
    } else if (type == "starts") {
      data_in |>
        filter(str_starts(string = !!sym(field), pattern = pattern))
    } else if (is_symbol_operator(type)) {
      dynamic_symbol_filter(data_in, type, field, pattern)
    }
  }, error = function(cond) {
    message <- glue(
      "Server-side error when filtering {field} with {value} and type {type}.\n",
      "Error: {cond$message}.\n",
      "Returning the unfiltered dataset."
    )
    warn(
      message = message,
      class = "ErrorFilter"
    )
    data_in
  })
}

#' @importFrom stringr fixed
parse_pattern <- function(data_in, type, value) {
  if (!inherits(data_in, "tbl_lazy")) {
    value
  } else {
    switch(
      type,
      "like" = fixed(value),
      "ends" = fixed(value),
      "starts" = fixed(value),
      value
    )
  }
}

is_symbol_operator <- function(type) {
  type %in% names(available_symbol_operators)
}


match_symbol_operator <- function(type) {
  available_symbol_operators[[type]]
}

#' @importFrom dplyr filter
#' @importFrom rlang parse_expr
#' @importFrom glue glue
dynamic_symbol_filter <- function(data_in, type, field, value) {
  operator <- match_symbol_operator(type)
  expr_str <- glue("{field} {operator} '{value}'")
  filtered_data <- data_in |>
    filter(!!rlang::parse_expr(expr_str))
  filtered_data
}

filter_data <- function(data_in, query_string) {
  # Get the filters from the query string
  all_filters <- parse_filters_from_query_string(query_string)
  if (length(all_filters) > 0) {
    for (each_filter in all_filters) {
      data_in <- run_filter_func(
        data_in = data_in,
        type = each_filter$type,
        field = each_filter$field,
        value = each_filter$value
      )
    }
  }
  data_in
}
