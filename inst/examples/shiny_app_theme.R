shiny::shinyApp(
  ui = fluidPage(
    selectInput(
      inputId = "theme",
      label = "Select Theme",
      choices = get_valid_theme_names()
    ),
    div(
      class = "table-container",
      tabulatorOutput("table")
    )
  ),
  server = function(input, output, session) {
    output$table <- renderTabulator({
      tabulator(
        data = people_data,
        theme = input$theme
      )
    })
  }
)