DEFAULT_THEME <- "bootstrap5" # nolint [object_name_linter]
themes_index <- list(
  simple = "css/tabulator_simple.min.css",
  midnight = "css/tabulator_midnight.min.css",
  modern = "css/tabulator_modern.min.css",
  site = "css/tabulator_site.min.css",
  bootstrap3 = "css/tabulator_bootstrap3.min.css",
  bootstrap4 = "css/tabulator_bootstrap4.min.css",
  bootstrap5 = "css/tabulator_bootstrap5.min.css",
  semantic = "css/tabulator_semanticui.min.css",
  bulma = "css/tabulator_bulma.min.css",
  materialize = "css/tabulator_materialize.min.css"
)

#' Get the list of valid themes
#' @export
get_valid_theme_names <- function() {
  names(themes_index)
}

is_valid_theme <- function(theme_name) {
  theme_name %in% get_valid_theme_names()
}

check_is_valid_theme <- function(theme_name) {
  if (!is_valid_theme(theme_name)) {
    cli_warn(
      c(
        "x" = "Invalid theme: {theme_name}",
        "i" = "Check for the valid options using {.run tabulator::get_valid_theme_names()}"
      )
    )
    theme_name <- DEFAULT_THEME
  }
  theme_name
}

#' @importFrom shiny getDefaultReactiveDomain
remove_css_dependencies <- function() {
  session <- getDefaultReactiveDomain()
  if (!is.null(session)) {
    session$sendCustomMessage("remove_css_dependencies", "")
  }
}

#' @importFrom htmltools htmlDependency
#' @importFrom digest digest
get_theme_dependency <- function(theme) {
  version <- digest(Sys.time())
  if (is.null(shiny::getDefaultReactiveDomain())) {
    name_html_dep <- sprintf("tabulator-htmlwidgets-css-%s", theme)
    stylesheet <- themes_index[[theme]]
  } else {
    name_html_dep <- sprintf("tabulator-htmlwidgets-css-%s-%s", theme, version)
    stylesheet <- sprintf("%s?version=%s", themes_index[[theme]], version)
  }
  htmlDependency(
    name = name_html_dep,
    version = "0.1",
    package = "tabulator",
    src = "htmlwidgets/dist",
    stylesheet = stylesheet,
    all_files = FALSE
  )
}
