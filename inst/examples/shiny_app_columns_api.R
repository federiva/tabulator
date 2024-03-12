library(shiny)
library(tabulator)

ui <- fluidPage(
  div(
    class = "help-container",
    h2("About this example"),
    h3("Columns API"),
    wellPanel(
      p(
        "This section provides sample cases that demonstrate the usage of column
        definitions and the usage of custom callbacks in formatter functions."
      ),
      p(
        span("Further assistance can be accessed by exploring the "),
        tags$a(
          href = "https://tabulator.info/docs/5.6/columns",
          target = "_blank",
          "Tabulator's documentation."
        )
      )
    )
  ),
  div(
    class = "table-container",
    tabulatorOutput(outputId = "table")
  ),
  div(
    class = "actions-container",
    h3(""),
    actionButton(
      inputId = "replace",
      label = "Replace Column Definitions"
    ),
    actionButton(
      inputId = "update",
      label = "Update Column Definition"
    )
  )
)

# Adding more data to our sample dataset
people_data$line_wrapping <- "Lorem ipsum dolor sit amet, elit consectetur adipisicing "
# Adding random numbers
people_data$money <- round(runif(10, 10e2, 10e4), 2)


server <- function(input, output, session) {

  output$table <- renderTabulator({
    tabulator(
      data = people_data
    ) |>
      tabulator_options(
        layout = "fitColumns"
      ) |>
      tabulator_columns(
        list(
          # Example of passing a JS callback to generate a tooltip element for a
          # given cell in this column.
          tabulator_column(
            field = "Name",
            title = "Name",
            minWidth = 200,
            maxWidth = 300,
            tooltip = JS(
              '
              function(e, cell, onRendered){
                const tooltipEl = document.createElement("div");
                tooltipEl.style.backgroundColor = "darkgray";
                tooltipEl.style.padding = "1rem";
                const income = cell.getData().money;
                tooltipEl.innerText = `Income: ${income}`
                return tooltipEl;
              }
              '
            )
          ),
          tabulator_column(
            field = "Progress",
            title = "Progress",
            formatter = "progress",
            sorter = "number",
            width = 150,
            resizable = FALSE,
            cssClass = "progress-col"
          ),
          tabulator_column(
            title = "Rating",
            field = "Rating",
            formatter = JS(
              '
                function(cell, formatterParams, onRendered) {
                  const cellValue = cell.getValue();
                  const cellEl = cell.getElement();
                  if (cellValue <= 2) {
                    cellEl.style.background = "red"
                  } else if (cellValue > 2 & cellValue <= 4) {
                    cellEl.style.background = "yellow"
                  } else (
                    cellEl.style.background = "green"
                  )
                }
              '
            ),
            hozAlign = "center",
            width = 120
          ),
          tabulator_column(
            title = "Line Wraping",
            field = "line_wrapping",
            formatter = "textarea"
          ),
          tabulator_column(
            formatter = "buttonTick",
            width = 30,
            hozAlign = "center"
          ),
          # Hiding this column in the browser. Note that we are using this column's
          # information within the Name's column definition above
          tabulator_column(
            field = "money",
            title = "Income",
            visible = FALSE
          )
        )
      )
  })

  observeEvent(input$replace, {
    replace_column_definitions(
      table_id = "table",
      columns = list(
        tabulator_column(
          field = "Name",
          title = "Name"
        ),
        tabulator_column(
          field = "Rating",
          title = "Rating *"
        )
      )
    )
  })

  observeEvent(input$update, {
    update_column_definition(
      table_id = "table",
      field = "money",
      column_definition =
        tabulator_column(
          field = "money",
          title = "money",
          visible = TRUE
        )
      )
  })


}

shinyApp(ui, server)
