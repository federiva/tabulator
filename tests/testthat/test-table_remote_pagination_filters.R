
test_that(
  "Remote pagination header filters", {
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
    while(isFALSE(app_connected)) {
      app_connected <- all(is.na(pingr::ping("http://127.0.0.1:9999")))
      Sys.sleep(0.1)
      connect_attempts <- connect_attempts+ 1
      if (connect_attempts > 20) {
        break
      }
    }
    # Wait until 2 secs to wait for the page to be rendered
    Sys.sleep(2)
    selenider::open_url("http://127.0.0.1:9999")

    selenider::s(".tabulator-cell") |>
      elem_expect(has_text("a"))

    column_names <- selenider::ss(".tabulator-col-title") |>
      lapply(function(x) {
        x |> selenider::elem_text()
      }) |> unlist()

    # All of the columns were properly rendered in the expected order
    expected_column_names <- c("let =", "let in", "eq =", "neq !=", "gt >", "gte >=", "lt <", "lte <=")
    expect_true(
      all(expected_column_names == column_names)
    )

    # Filtering a text column with the = function leaves only one row
    filters <- ss(".tabulator-header-filter input")
    filter <- filters[[1]]
    filter |>
      selenider::elem_focus()
    Sys.sleep(1)
    filter |>
      selenider::elem_send_keys("a")
    Sys.sleep(1)
    expect_true(
      ss(".tabulator-row") |> has_length(1)
    )
    # Adding an additional letter will leave no row displayed
    filter |>
      selenider::elem_send_keys("a")
    Sys.sleep(1)
    expect_true(
      ss(".tabulator-row") |> has_length(0)
    )

    # Removing the two entered letters will display the entire table
    selenider::elem_clear_value(filter)
    Sys.sleep(1)
    expect_true(
      ss(".tabulator-row") |> has_length(5)
    )

    # Selecting the IN filter and entering abc will result in two rows
    filter <- filters[[2]]

    filter |>
      selenider::elem_focus()
    Sys.sleep(1)
    filter |>
      selenider::elem_send_keys("abc")
    Sys.sleep(1)
    expect_true(
      ss(".tabulator-row") |> has_length(2)
    )

    # Removing the two entered letters will display the entire table
    selenider::elem_clear_value(filter)
    Sys.sleep(1)
    expect_true(
      ss(".tabulator-row") |> has_length(5)
    )


    # Selecting the = numeric filter and entering 6 will result in one row
    filter <- filters[[3]]

    filter |>
      selenider::elem_focus()
    Sys.sleep(1)
    filter |>
      selenider::elem_send_keys("6")
    Sys.sleep(1)
    expect_true(
      ss(".tabulator-row") |> has_length(1)
    )

    # The value is the expected
    expect_equal(
      s(".tabulator-row") |> find_element(xpath = ".//div[@tabulator-field='numbers_eq']") |> selenider::elem_text(),
      "6"
    )

    # Removing the two entered letters will display the entire table
    selenider::elem_clear_value(filter)
    Sys.sleep(1)
    expect_true(
      ss(".tabulator-row") |> has_length(5)
    )


    # Selecting the not equal to numeric filter and entering 1 will result in NOT
    # displaying the value 1 in the table
    filter <- filters[[4]]

    filter |>
      selenider::elem_focus()
    Sys.sleep(1)
    filter |>
      selenider::elem_send_keys("1")
    Sys.sleep(1)
    expect_true(
      ss(".tabulator-row") |> has_length(5)
    )

    # The value 1 is not present in the table as expected
    all_values_in_column <- ss(xpath = ".//div[@tabulator-field='numbers_ne']") |>
      lapply(elem_text) |>
      unlist()

    expect_false(
      any("1" %in% all_values_in_column)
    )

    # Removing the two entered letters will display the entire table
    selenider::elem_clear_value(filter)
    Sys.sleep(1)
    expect_true(
      ss(".tabulator-row") |> has_length(5)
    )


    # Selecting the greater than numeric filter and entering 8 will result in
    # two rows displaying the numbers 9 and 10
    filter <- filters[[5]]

    filter |>
      selenider::elem_focus()
    Sys.sleep(1)
    filter |>
      selenider::elem_send_keys("8")
    Sys.sleep(1)
    expect_true(
      ss(".tabulator-row") |> has_length(2)
    )

    # The table is only showing values greater than 8, therefore only 9 and 10
    all_values_in_column <- ss(xpath = ".//div[@class='tabulator-table']//div[@tabulator-field='numbers_gt']") |>
      lapply(elem_text) |>
      unlist()

    expect_true(
      all(c("9", "10") == all_values_in_column)
    )

    # Removing the two entered letters will display the entire table
    selenider::elem_clear_value(filter)
    Sys.sleep(1)
    expect_true(
      ss(".tabulator-row") |> has_length(5)
    )

    # Selecting the greater than or equal to numeric filter and entering 8 will
    # result in thre rows displaying the numbers 8, 9 and 10
    filter <- filters[[6]]

    filter |>
      selenider::elem_focus()
    Sys.sleep(1)
    filter |>
      selenider::elem_send_keys("8")
    Sys.sleep(1)
    expect_true(
      ss(".tabulator-row") |> has_length(3)
    )

    # The table is only showing values greater or equal to 8, therefore only 8, 9 and 10
    all_values_in_column <- ss(xpath = ".//div[@class='tabulator-table']//div[@tabulator-field='numbers_gte']") |>
      lapply(elem_text) |>
      unlist()

    expect_true(
      all(c("8", "9", "10") == all_values_in_column)
    )

    # Removing the two entered letters will display the entire table
    selenider::elem_clear_value(filter)
    Sys.sleep(1)
    expect_true(
      ss(".tabulator-row") |> has_length(5)
    )

    # Selecting the less than numeric filter and entering 3 will
    # result in two rows displaying the numbers 1 and 2
    filter <- filters[[7]]

    filter |>
      selenider::elem_focus()
    Sys.sleep(1)
    filter |>
      selenider::elem_send_keys("3")
    Sys.sleep(1)
    expect_true(
      ss(".tabulator-row") |> has_length(2)
    )

    # The table is only showing values less than 3, therefore only 1 and 2
    all_values_in_column <- ss(xpath = ".//div[@class='tabulator-table']//div[@tabulator-field='numbers_lt']") |>
      lapply(elem_text) |>
      unlist()

    expect_true(
      all(c("1", "2") == all_values_in_column)
    )

    # Removing the two entered letters will display the entire table
    selenider::elem_clear_value(filter)
    Sys.sleep(1)
    expect_true(
      ss(".tabulator-row") |> has_length(5)
    )

    # Selecting the less or equal than numeric filter and entering 3 will
    # result in two rows displaying the numbers 1, 2 and 3
    filter <- filters[[8]]

    filter |>
      selenider::elem_focus()
    Sys.sleep(1)
    filter |>
      selenider::elem_send_keys("3")
    Sys.sleep(1)
    expect_true(
      ss(".tabulator-row") |> has_length(3)
    )

    # The table is only showing values less or equal than 3, therefore only 1, 2 and 3
    all_values_in_column <- ss(xpath = ".//div[@class='tabulator-table']//div[@tabulator-field='numbers_lte']") |>
      lapply(elem_text) |>
      unlist()

    expect_true(
      all(c("1", "2", "3") == all_values_in_column)
    )

    # Removing the two entered letters will display the entire table
    selenider::elem_clear_value(filter)
    Sys.sleep(1)
    expect_true(
      ss(".tabulator-row") |> has_length(5)
    )

    on.exit({
      shiny_proc$kill()
    })

})
