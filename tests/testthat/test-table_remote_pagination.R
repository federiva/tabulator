test_that(
  "Remote pagination pages",
  {
    skip_on_cran()
    shiny_proc <- callr::r_bg(
      func = function() {
        library(shiny)
        devtools::load_all()
        path_file <- system.file("examples/shiny_app_remote_database_pagination.R", package = "tabulator")
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
    Sys.sleep(1)
    # Taking a screenshot to force the visibility of a button
    # TODO (Feb 2024) Try to reproduce this issue to submit an issue to the selenider repo
    selenider::take_screenshot(tempfile(fileext = ".png"))
    # Check that the next button exists and we can click it
    next_button <- selenider::s(xpath = ".//span[@class='tabulator-paginator']//button[@data-page='next']")
    next_button |>
      elem_expect(has_text("Next"))

    selenider::elem_click(x = next_button)
    Sys.sleep(2)

    # Check that the fourth column (eq =) has the expected values after clicking
    # the next button to go to the second page

    # The table is only showing values from the second page
    all_values_in_column <- ss(xpath = ".//div[@class='tabulator-table']//div[@tabulator-field='numbers_eq']") |>
      lapply(elem_text) |>
      unlist()

    expect_true(
      all(c("6", "7", "8", "9", "10") == all_values_in_column)
    )

    # Go back to the first page and check the values
    # Check that the prev button exists and we can click it
    prev_button <- selenider::s(xpath = ".//span[@class='tabulator-paginator']//button[@data-page='prev']")
    prev_button |>
      elem_expect(has_text("Prev"))

    selenider::elem_click(x = prev_button)
    Sys.sleep(2)

    # Check that the fourth column (eq =) has the expected values after clicking
    # the prev button to go to the first page

    # The table is only showing values from the first page
    all_values_in_column <- ss(xpath = ".//div[@class='tabulator-table']//div[@tabulator-field='numbers_eq']") |>
      lapply(elem_text) |>
      unlist()

    expect_true(
      all(c("1", "2", "3", "4", "5") == all_values_in_column)
    )
  }
)
