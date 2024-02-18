run_checks <- function(tabulator_object) {
  print("perform checks")
  tabulator_object |>
    check_for_valid_nested_separator()
}

check_for_valid_nested_separator <- function(tabulator_object) {
  tabulator_object
}
