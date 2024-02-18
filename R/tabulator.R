#' Tabulator table
#'
#' Renders a tabulator table
#'
#' @import htmlwidgets
#'
#' @export
tabulator <- function(
  data = NULL,
  width = NULL,
  height = NULL,
  elementId = NULL,
  nested_field_separator = ".."
) {
  # forward options using x
  params = list(
    data = data
  )
  attr(params, 'TOJSON_ARGS') <- list(dataframe = "rows")
  # create widget
  htmlwidgets::createWidget(
    name = 'tabulator',
    x = params,
    width = width,
    height = height,
    package = 'tabulator',
    elementId = elementId
  ) |>
    add_default_table_options()
}

#' Shiny bindings for tabulator
#'
#' Output and render functions for using tabulator within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a tabulator
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name tabulator-shiny
#'
#' @export
tabulatorOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'tabulator', width, height, package = 'tabulator')
}

#' @rdname tabulator-shiny
#' @export
renderTabulator <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(run_checks(expr))
  }
  htmlwidgets::shinyRenderWidget(expr, tabulatorOutput, env, quoted = TRUE)
}
