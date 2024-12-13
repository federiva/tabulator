% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/spreadsheet.R
\name{check_if_single_spreadsheet}
\alias{check_if_single_spreadsheet}
\title{Check If Single Spreadsheet}
\usage{
check_if_single_spreadsheet(tabulator_object, ...)
}
\arguments{
\item{tabulator_object}{The tabulator object to be modified.}

\item{...}{Additional options to be considered for the spreadsheet.
- \code{data}: A dataframe to be used as the spreadsheet data.
- \code{spreadsheetSheets}: Sheets to be included in the spreadsheet if \code{data} is not provided.}
}
\value{
Modified tabulator object with the spreadsheet options adjusted.
}
\description{
This function checks if a given \code{tabulator_object} should be treated as a single spreadsheet.
It sets the \code{spreadsheet} option to \code{TRUE} and adjusts the data based on the provided options.
If \code{data} is specified in the options, it is converted and assigned to the \code{tabulator_object}.
If \code{data} is not provided but \code{spreadsheetSheets} is not specified either, a warning is issued,
and an empty spreadsheet is initialized. Any additional options are appended to the \code{table_options}.
}
