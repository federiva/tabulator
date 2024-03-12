#' @importFrom shiny tagList hr div checkboxInput conditionalPanel
#' @importFrom highlighter highlighterOutput
highlighter_ui <- function() {
  tagList(
    hr(),
    div(
      class = "code-container",
      div(
        class = "tabulator-highlighter",
        checkboxInput(
          inputId = "show_code",
          label = "Show code for this example",
          value = TRUE
        )
      ),
      div(
        conditionalPanel(
          condition = "input.show_code",
          highlighterOutput("code")
        )
      )
    )
  )
}


#' @importFrom highlighter highlight_file renderHighlighter
highlighter_server <- function(input, output, app_name) {
  output$code <- renderHighlighter({
    highlight_file(
      get_valid_app_names()[[app_name]],
    )
  })
}
