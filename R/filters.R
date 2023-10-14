available_symbol_operators <- list(
  `=` = "==",
  `<` = "<",
  `>` = ">",
  `<=` = "<=",
  `>=` = ">=",
  `in` = "%in%"
)

#' @importFrom glue glue
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


#' @importFrom stringr str_detect
#' @importFrom rlang sym
#' @importFrom dplyr filter
run_filter_func <- function(data_in, type, field, value) {
  if (type == "like") {
    data_in |>
      filter(str_detect(!!sym(field), value))
  } else if (is_symbol_operator(type)) {
    dynamic_symbol_filter(data_in, type, field, value)
  }
}


is_symbol_operator <- function(type) {
  type %in% names(available_symbol_operators)
}


match_symbol_operator <- function(type) {
  available_symbol_operators[[type]]
}

dynamic_symbol_filter <- function(data_in, type, field, value) {
  operator <- match_symbol_operator(type)
  expr_str <- paste0("!!sym(field) ", operator, " value")
  expr_str <- glue("!!{field} {operator} {value}")
  expr <- rlang::parse_expr(expr_str)
  data_in |>
    filter(rlang::eval_tidy(expr))
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

# cola <- parse_filters_from_query_string(query_string)

