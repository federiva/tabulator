test_that(
  "Server pagination sorters",
  {
    skip_on_cran()
    shiny_proc <- callr::r_bg(
      func = function() {
        library(shiny)
        devtools::load_all()
        run_example_app("server_pagination")
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
    Sys.sleep(1)
    # Taking a screenshot to force the visibility of a button
    # TODO (Feb 2024) Try to reproduce this issue to submit an issue to the selenider repo
    selenider::take_screenshot(tempfile(fileext = ".png"))
    # Check that the sorter arrow button exists and we can click it
    sorter_arrow <- selenider::s(xpath = ".//div[@tabulator-field='numbers_ne']//div[@class='tabulator-arrow']")

    selenider::elem_click(x = sorter_arrow)
    Sys.sleep(2)

    # The table is only showing values in increasing order
    all_values_in_column <- ss(xpath = ".//div[@class='tabulator-table']//div[@tabulator-field='numbers_ne']") |>
      lapply(elem_text) |>
      unlist()

    expect_true(
      all(c("1", "2", "3", "4", "5") == all_values_in_column)
    )

    # Click the arrow sorter again
    selenider::elem_click(x = sorter_arrow)
    Sys.sleep(2)
    # Check that the fourth column (eq =) has the expected values after clicking
    # the next button to go to the second page

    # The table is only showing values in decreasing order
    all_values_in_column <- ss(xpath = ".//div[@class='tabulator-table']//div[@tabulator-field='numbers_ne']") |>
      lapply(elem_text) |>
      unlist()

    expect_true(
      all(c("10", "9", "8", "7", "6") == all_values_in_column)
    )
  }
)
