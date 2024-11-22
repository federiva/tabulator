# tabulator <img src="man/figures/logo.png" align="right" height="139" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/YOUR_USERNAME/tabulator/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/YOUR_USERNAME/tabulator/actions/workflows/R-CMD-check.yaml)
[![CRAN status](https://www.r-pkg.org/badges/version/tabulator)](https://CRAN.R-project.org/package=tabulator)
<!-- badges: end -->

## Overview

The tabulator package provides R bindings to the [Tabulator](https://tabulator.info/) JavaScript library, enabling you to create interactive tables in R and Shiny applications. It offers a wide range of features including:

- Interactive data tables with sorting, filtering, and pagination
- Multiple themes and styling options
- Client and server-side data processing
- Advanced column configurations and formatters
- Spreadsheet-like editing capabilities
- Integration with various database backends

## Installation

* Using remotes
```R
remotes::install_github("federiva/tabulator")
```

* Using renv
```R
# From CRAN
renv::install("tabulator")
# Development version from github
renv::install("federiva/tabulator")
```

## Usage
See the vignettes for more examples.

## Main Features

### Column Definitions

Customize columns with various formatters, editors, and validators.

### Server-Side Processing

Server side and remote server side processing


Support for server-side processing with various database backends:
- PostgreSQL
- MySQL
- SQLite
- DuckDB

### Interactive Features

- Row selection
- Column resizing and reordering
- Data editing
- Copy/paste functionality
- Undo/redo capabilities
- Data export


# Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

* [Tabulator](https://tabulator.info/) - The JavaScript library this package wraps
* The R community for their continuous support and feedback
