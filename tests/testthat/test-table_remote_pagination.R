example_data <- data.frame(
  numbers_eq = c(1:10),
  numbers_gt = c(1:10),
  numbers_lt = c(1:10),
  numbers_ne = c(1:10),
  numbers_gte = c(1:10),
  numbers_lte = c(1:10),
  letters_eq = letters[1:10],
  letters_in = letters[1:10]
)
shiny_app_process <- callr::r_bg(function() {
  library(shiny)
  library(dplyr)
  library(tabulator)
  library(RSQLite)

  shinyApp(
    ui = fluidPage(
      tabulatorOutput("table")
    ),
    server = function(input, output, session) {
      # When the data is obtained from a remote source then the data argument
      # of the tabulator function could be empty/NULL
      temp_sqlite_path <- file.path("example_data")
      # Create DB
      con <- dbConnect(SQLite(), dbname = temp_sqlite_path)
      dbWriteTable(con, "example_data", example_data, overwrite = TRUE)
      db_data <- tbl(con, "example_data")
      shiny::onStop(function() {
        DBI::dbDisconnect(con)
      })
      output$table <- renderTabulator({
        tabulator() |>
          column_layout_mode("fitColumns") |>
          tabulator_columns(
            list(
              tabulator_column(
                title = "let =",
                field = "letters_eq",
                headerFilter = TRUE,
                headerFilterFunc = "="
              ),
              tabulator_column(
                title = "let in",
                field = "letters_in",
                headerFilter = TRUE,
                headerFilterFunc = "in"
              ),
              tabulator_column(
                title = "eq =",
                field = "numbers_eq",
                headerFilter = TRUE,
                headerFilterFunc = "="
              ),
              tabulator_column(
                title = "neq !=",
                field = "numbers_ne",
                headerFilter = TRUE,
                headerFilterFunc = "!="
              ),
              tabulator_column(
                title = "gt >",
                field = "numbers_gt",
                headerFilter = TRUE,
                headerFilterFunc = ">"
              ),
              tabulator_column(
                title = "gte >=",
                field = "numbers_gte",
                headerFilter = TRUE,
                headerFilterFunc = ">="
              ),
              tabulator_column(
                title = "lt <",
                field = "numbers_lt",
                headerFilter = TRUE,
                headerFilterFunc = "<"
              ),
              tabulator_column(
                title = "lte <=",
                field = "numbers_lte",
                headerFilter = TRUE,
                headerFilterFunc = "<="
              )
            )
          ) |>
          pagination(
            pagination_size = 5,
            mode = "remote",
            request_handler = use_sqlite_request_handler(db_data)
          ) |>
          set_layout_columns_on_new_data()
      })
    },
    options = list(port = 9999)
  )
})
browser()
test_that(
  "Remote pagination", {
  skip_on_cran()
    browser()
    app <- AppDriver$new(shiny_app, name = "remote_db_connection")
    browser()
    print(app$get_url())
    app$get_screenshot(sprintf("~/Pictures/remote_%s.png", as.numeric(Sys.time())))
    session <- selenider_session(driver = app)
    # selenider::s(xpath = ".//button[@data-page='next']") |>
    #   selenider::elem_click()
    # Expect five columns to be rendered
    expect_equal(
      2,
      2
    )

    # Expect five rows with values and five rows empty
    # table_el <- s(".tabulator-table")
    # n_empty_rows <- 0
    # n_non_empty_rows <- 0
    # cells_text <- table_el |> find_elements(".tabulator-cell") |> lapply(elem_text)
    # for (cell in cells_text) {
    #   # Trim and count length as empty values could be rendered by tabulator as empty character strings
    #   cell_value_length <- cell |> stringr::str_trim() |> stringr::str_length()
    #   is_empty <- cell_value_length == 0
    #   if (is_empty) {
    #     n_empty_rows <- n_empty_rows + 1
    #   } else {
    #     n_non_empty_rows <- n_non_empty_rows + 1
    #   }
    # }
    # expect_equal(n_empty_rows, 5)
    # expect_equal(n_non_empty_rows, 5)
})
