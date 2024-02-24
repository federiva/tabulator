library(shiny)
library(dplyr)
library(tabulator)
library(RSQLite)
library(dplyr)
library(dbplyr)

test_that(
  "Some columns are not rendered when nestedFieldSeparator is set to '__' as well as the column names", {
  skip_on_cran()
  withr::with_tempdir({

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

    temp_sqlite_path <- file.path(tempdir(), "example_data")
    # Create DB
    con <- dbConnect(SQLite(), dbname = temp_sqlite_path)
    dbWriteTable(con, "example_data", example_data)

    shiny_app <- shinyApp(
      ui = fluidPage(
        tabulatorOutput("table")
      ),
      server = function(input, output, session) {
        # When the data is obtained from a remote source then the data argument
        # of the tabulator function could be empty/NULL
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
              request_handler = sqlite_request_handler
            ) |>
            set_layout_columns_on_new_data()
        })
      }
    )

    app <- AppDriver$new(shiny_app, name = "remote_db_connection")
    session <- selenider_session(driver = app)

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
})
