library(tabulator)
test_that(
  "Some columns are not rendered when nestedFieldSeparator is set to '__' as well as the column names",
  {
    skip_on_cran()
    skip_on_cran()
    shiny_proc <- callr::r_bg(
      func = function() {
        library(shiny)
        devtools::load_all()
        path_file <- system.file("examples/shiny_app_options_nested_field_separator.R", package = "tabulator")
        shiny::runApp(
          path_file,
          port = 9999
        )
      },
      supervise = TRUE
    )
    app_connected <- FALSE
    connect_attempts <- 0
    while (isFALSE(app_connected)) {
      app_connected <- all(is.na(pingr::ping("http://127.0.0.1:9999")))
      Sys.sleep(0.1)
      connect_attempts <- connect_attempts + 1
      if (connect_attempts > 20) {
        break
      }
    }
    on.exit({
      shiny_proc$kill()
    })

    # Wait until 2 secs to wait for the page to be rendered
    Sys.sleep(2)
    selenider::open_url("http://127.0.0.1:9999")
    Sys.sleep(2)
    # Expect five columns to be rendered
    expect_equal(
      ss(".tabulator-col-title") |>
        elem_size(),
      5
    )

    # Expect five rows with values and five rows empty
    table_el <- s(".tabulator-table")
    n_empty_rows <- 0
    n_non_empty_rows <- 0
    cells_text <- table_el |>
      find_elements(".tabulator-cell") |>
      lapply(elem_text)
    for (cell in cells_text) {
      # Trim and count length as empty values could be rendered by tabulator as empty character strings
      cell_value_length <- cell |>
        stringr::str_trim() |>
        stringr::str_length()
      is_empty <- cell_value_length == 0
      if (is_empty) {
        n_empty_rows <- n_empty_rows + 1
      } else {
        n_non_empty_rows <- n_non_empty_rows + 1
      }
    }
    expect_equal(n_empty_rows, 10)
    expect_equal(n_non_empty_rows, 15)
  }
)
