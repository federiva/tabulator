#' @importFrom glue glue
#' @noRd
parse_sorters_from_query_string <- function(query_string) {
  sorter_names <- grep(
    pattern = "^sort\\[\\d+\\]\\[[a-zA-Z]+\\]$",
    x = names(query_string),
    value = TRUE
  )
  parsed_sorters <- list()
  if (length(sorter_names) > 0) {
    indexes <- extract_unique_numbers_from_query_string(sorter_names)
    seq <- 1
    for (index in indexes) {
      field_name <- glue("sort[{index}][field]")
      direction <- glue("sort[{index}][dir]")
      parsed_sorters[[seq]] <- list(
        field = query_string[[field_name]],
        direction = query_string[[direction]]
      )
      seq <- seq + 1
    }
  }
  parsed_sorters
}


#' @importFrom dplyr arrange sym
run_sorter_func <- function(data_in, field, direction) {
  if (direction == "asc") {
    data_in |>
      arrange(!!sym(field))
  } else if (direction == "desc") {
    data_in |>
      arrange(desc(!!sym(field)))
  }
}

sort_data <- function(data_in, query_string) {
  sorters <- parse_sorters_from_query_string(query_string)
  if (length(sorters) > 0) {
    for (sorter in sorters) {
      data_in <- run_sorter_func(
        data_in = data_in,
        field = sorter$field,
        direction = sorter$direction
      )
    }
  }
  data_in
}
