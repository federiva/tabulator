# plumber.R

# Load required libraries
library(plumber)
library(dplyr)

# Define the paginate function
paginate_dataframe <- function(df, page_number, page_size) {
  colnames(df) <- stringi::stri_replace_all(str = colnames(df), replacement = "_", regex = "\\.")
  start_row <- (page_number - 1) * page_size + 1
  end_row <- page_number * page_size
  subset_df <- df[start_row:min(end_row, nrow(df)), ]
  list(
    data = subset_df,
    last_page = ceiling(nrow(df) / page_size)
  )
}

#* @apiTitle Iris Data API

#* Return a paginated subset of the iris dataset
#* @param page Query parameter: Page number (default is 1)
#* @param page_size Query parameter: Number of rows per page (default is 10)
#* @get /iris
function(page = 1, page_size = 10) {
  page <- as.numeric(page)
  page_size <- as.numeric(page_size)
  response_data <- paginate_dataframe(iris, page, page_size)
  jsonlite::toJSON(
    x = list(
      data = response_data$data,
      last_page = response_data$last_page
    ),
    dataframe = "rows"
  )
}
