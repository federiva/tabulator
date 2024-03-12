# TODO
# datetime and datetimediff are not currently working
builtin_formatters <- c(
  "buttonCross", "buttonTick", "color", "datetime", "datetimediff", "handle",
  "html", "image", "link", "lookup", "money", "plaintext", "progress", "rownum",
  "star", "textarea", "tickCross", "traffic"
)

builtin_formatters_params <- list(
  # https://tabulator.info/docs/5.6/format#formatter-money
  money = list(
    decimal = ".",
    negativeSign = TRUE,
    precision = FALSE,
    symbol = "$",
    symbolAfter = "p",
    thousand = ","
  ),
  # https://tabulator.info/docs/5.6/format#formatter-image
  image = list(
    height = "50px", # character
    width = "50px", # character
    urlPrefix = "http://website.com/images/", # character
    urlSuffix = ".png" # character
  ),
  # https://tabulator.info/docs/5.6/format#formatter-link
  link = list(
    labelField = "name",
    target = "_blank",
    urlPrefix = "mailto://"
  ),
  datetime = list(
    inputFormat = "yyyy-MM-dd HH:ss",
    invalidPlaceholder = "(invalid date)",
    outputFormat = "dd/MM/yy",
    timezone = "America/Los_Angeles"
  ),
  # https://tabulator.info/docs/5.6/format#formatter-datetimediff
  datetimediff = list(
    humanize = TRUE,
    inputFormat = "yyyy-MM-dd",
    invalidPlaceholder = "(invalid date)",
    unit = list("months", "days", "hours")
  ),
  # https://tabulator.info/docs/5.6/format#formatter-tickcross
  tickCross = list(
    allowEmpty = TRUE,
    allowTruthy = TRUE,
    crossElement = "<i class='fa fa-times'></i>",
    tickElement = "<i class='fa fa-check'></i>"
  ),
  # https://tabulator.info/docs/5.6/format#formatter-star
  star = list(
    starts = 8
  ),
  # https://tabulator.info/docs/5.6/format#formatter-traffic
  traffic = list(
    color = list("green", "orange", "red"),
    max = 10,
    min = 0
  ),
  # https://tabulator.info/docs/5.6/format#formatter-progress
  progress = list(
    color = list("green", "orange", "red"),
    legend = TRUE,
    legendAlign = "center",
    legendColor = "#000000",
    max = 10,
    min = 0
  ),
  # https://tabulator.info/docs/5.6/format#formatter-lookup
  lookup = list(
    big = "Scary",
    medium = "Fine",
    small = "Cute"
  )
)

#' @importFrom cli cli_h1 cli_inform symbol
#' @export
show_example_builtin_params <- function(builtin_formatter) {
  cli::cli_h1("Tabulator - Builtin Formatters")
  if (!builtin_formatter %in% builtin_formatters | is.null(builtin_formatter)) {
    cli_inform(
      c(
        "x" = "The input formatter {builtin_formatter} is not valid. Must be one of: ",
        "i" = "{names(builtin_formatters_params)}"
      )
    )
  } else {
    cli_inform(
      c(
        "i" = "The input formatter {builtin_formatter} has the following parameters: ",
        "{names(builtin_formatters_params[[builtin_formatter]])}",
        "",
        "These should be entered as a named list to the `tabulator_column` function",
        "i" = "Run {.run tabulator::get_example_builtin_param(\"{builtin_formatter}\")} to get an example list of parameters",
        "{symbol$fancy_question_mark} For additional help you can check the documentation in {.url https://tabulator.info/docs/5.6/format#format-builtin}"
      )
    )
  }
}

#' @export
get_example_builtin_param <- function(builtin_formatter) {
  builtin_formatters_params[[builtin_formatter]]
}

#' @importFrom cli cli_h1 cli_inform symbol
#' @export
get_builtin_formatters <- function() {
  link <- "https://tabulator.info/docs/5.6/format"
  cli::cli_h1("Tabulator - Builtin Formatters")
  cli_inform(
    c(
      "i" = "Builtin formatters are: {builtin_formatters}",
      "",
      "{symbol$fancy_question_mark} Check for the valid formatter parameters for a given formatter using {.run tabulator::show_example_builtin_params(\"progress\")}" # nolint
    )
  )
}
