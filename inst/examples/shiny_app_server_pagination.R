library(shiny)
library(tabulator)


example_data <- data.frame(
  numbers_eq = c(1:10),
  numbers_gt = c(1:10),
  numbers_lt = c(1:10),
  numbers_ne = c(1:10),
  numbers_gte = c(1:10),
  numbers_lte = c(1:10),
  letters_eq = letters[1:10],
  letters_in = c("abc", "def", "ghi", "jkl", "mnñ", "opq", "rst", "uvw", "xyz", "abc"),
  letters_regex = c("abc", "def", "ghi", "jkl", "mnñ", "opq", "rst", "uvw", "xyz", "abc"),
  letters_ends = c("abc", "def", "ghi", "jkl", "mnñ", "opq", "rst", "uvw", "xyz", "abc"),
  letters_starts = c("abc", "def", "ghi", "jkl", "mnñ", "opq", "rst", "uvw", "xyz", "abc")
)

ui <- fluidPage(
  tabulatorOutput("table"),
  highlighter_ui()
)

server <- function(input, output, session) {

  output$table <- renderTabulator({
    tabulator(example_data) |>
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
          ),
          tabulator_column(
            title = "regex",
            field = "letters_regex",
            headerFilter = TRUE,
            headerFilterFunc = "regex"
          ),
          tabulator_column(
            title = "ends",
            field = "letters_ends",
            headerFilter = TRUE,
            headerFilterFunc = "ends"
          ),
          tabulator_column(
            title = "starts",
            field = "letters_starts",
            headerFilter = TRUE,
            headerFilterFunc = "starts"
          )
        )
      ) |>
      column_layout_mode("fitColumns") |>
      set_layout_columns_on_new_data() |>
      pagination(pagination_size = 5, mode = "server")
  })

  highlighter_server(input, output, "server_pagination")

}

shinyApp(ui, server)
