library(tabulator)
test_that(
  "Some columns are not rendered when nestedFieldSeparator is set to '__' as well as the column names", {
  skip_on_cran()
  input_data <- data.frame(
    `id..a` = c(1:5),
    `id__ax` = c(1:5)
  )
  shiny_app <- shinyApp(
    ui = fluidPage(
      tabulatorOutput("table")
    ),
    server = function(input, output, session) {
      output$table <- renderTabulator({
        tabulator(input_data) |>
          tabulator_options(
            nestedFieldSeparator = "__"
          )
      })
    }
  )
  app <- AppDriver$new(shiny_app, name = "nested_field_separator")
  session <- selenider_session(driver = app)
  # Expect five columns to be rendered
  expect_equal(
    ss(".tabulator-col-title") |>
      elem_size(),
    2
  )

  # Expect five rows with values and five rows empty
  table_el <- s(".tabulator-table")
  n_empty_rows <- 0
  n_non_empty_rows <- 0
  cells_text <- table_el |> find_elements(".tabulator-cell") |> lapply(elem_text)
  for (cell in cells_text) {
    # Trim and count length as empty values could be rendered by tabulator as empty character strings
    cell_value_length <- cell |> stringr::str_trim() |> stringr::str_length()
    is_empty <- cell_value_length == 0
    if (is_empty) {
      n_empty_rows <- n_empty_rows + 1
    } else {
      n_non_empty_rows <- n_non_empty_rows + 1
    }
  }
  expect_equal(n_empty_rows, 5)
  expect_equal(n_non_empty_rows, 5)
})
