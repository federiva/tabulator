library(shiny)
library(tabulator)

ui <- fluidPage(
  div(
    class = "help-container",
    h2("About this example"),
    h3("Clipboard"),
    wellPanel(
      p(
        "This section provides sample cases that demonstrate the usage of functions
        to copy the table. You can either use the functions in the Shiny server
        side or you can just press ctrl+c and that will copy the active table
        to the clipboard."
      ),
      p(
        span("Further assistance can be accessed by exploring the "),
        tags$a(
          href = "https://tabulator.info/docs/5.6/clipboard",
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
      inputId = "copy",
      label = "Copy table to clipboard"
    ),
    actionButton(
      inputId = "update",
      label = "Update Column Definition"
    ),
    actionButton(
      inputId = "add_column",
      label = "Add a new column"
    ),
    actionButton(
      inputId = "delete_column",
      label = "Delete Name Column"
    )
  ),
  highlighter_ui()
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
        layout = "fitColumns",
        clipboard = TRUE,
        clipboardCopyConfig = list(
          columnHeaders = TRUE, # include column headers in clipboard output (default)
          columnGroups = FALSE, # do not include column groups in column headers for printed table
          rowGroups = FALSE, # do not include row groups in clipboard output
          columnCalcs = FALSE, # do not include column calculation rows in clipboard output
          dataTree = FALSE, # do not include data tree in printed table
          formatCells = FALSE # show raw cell values without formatter
        ),
        clipboardPasteParser = "table"
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
            width = 120,
            clipboard = FALSE # This column will not be copied to the clipboard
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
          tabulator_column(
            field = "money",
            title = "Income"
          )
        )
      )
  })

  observeEvent(input$copy, {
    copy_table("table")
  })

  observeEvent(input$update, {
    update_column_definition(
      table_id = "table",
      field = "money",
      column_definition = tabulator_column(
        field = "money",
        title = "money",
        visible = TRUE
      )
    )
  })

  observeEvent(input$add_column, {
    add_column(
      table_id = "table",
      column_definition = tabulator_column(
        field = "Favourite_Color",
        title = "C",
        formatter = "color",
        maxWidth = 50
      ),
      position = "Name"
    )
  })

  observeEvent(input$delete_column, {
    delete_column(
      table_id = "table",
      field = "Name"
    )
  })

  highlighter_server(
    input = input,
    output = output,
    app_name = "clipboard"
  )
}

shinyApp(ui, server)
