# nolint start
# https://tabulator.info/docs/6.2/columns

# title - Required This is the title that will be displayed in the header for this column
# field - Required (not required in icon/button columns) this is the key for this column in the data array
# visible - (boolean, default - true) determines if the column is visible. (see Column Visibility for more details)

# hoz_align - sets the horizontal text alignment for this column (left|center|right)
# vert_align - sets the vertical text alignment for this column (top|middle|bottom)
# header_hoz_align - sets the horizontal text alignment for this columns header title (left|center|right)
# width - sets the width of this column, this can be set in pixels or as a percentage of total table width (if not set the system will determine the best)
# min_width - sets the minimum width of this column, this should be set in pixels
# max_width - sets the maximum width of this column, this should be set in pixels
# max_initial_width - sets the maximum width of this column when it is first rendered, the user can then resize to above this (up to the maxWidth, if set) this should be set in pixels
# width_grow - when using fitColumns layout mode, determines how much the column should grow to fill available space (see Table Layout for more details)
# width_shrink - when using fitColumns layout mode, determines how much the column should shrink to fit available space (see Table Layout for more details)
# resizable - set whether column can be resized by user dragging its edges (see Table Layout for more details)
# frozen - freezes the column in place when scrolling (see Frozen Columns for more details)
# responsive - an integer to determine when the column should be hidden in responsive mode (see Responsive Layout for more details)
# tooltip - sets the on hover tooltip for each cell in this column (see Formatting Data for more details)
# css_class - sets css classes on header and cells in this column. (value should be a string containing space separated class names)
# row_handle - sets the column as a row handle, allowing it to be used to drag movable rows. (see Movable Rows for more details)
# html_output - show or hide column in the getHtml function output (see Retrieve Data as HTML Table for more details)
# print - show or hide column in the print output (see Printing for more details)
# clipboard - show or hide column in the clipboard output (see Clipboard for more details)

# column header params
# header_sort - user can sort by clicking on the header (see Sorting Data for more details)
# header_sort_starting_dir - set the starting sort direction when a user first clicks on a header (see Sorting Data for more details)
# header_sort_tristate - allow tristate toggling of column header sort direction (see Sorting Data for more details)
# header_click - callback for when user clicks on the header for this column (see Callbacks for more details)
# header_dbl_click - callback for when user double clicks on the header for this column (see Callbacks for more details)
# header_context - callback for when user right clicks on the header for this column (see Callbacks for more details)
# header_tap - callback for when user taps on a header for this column, triggered in touch displays. (see Callbacks for more details)
# header_dbl_tap - callback for when user double taps on a header for this column, triggered in touch displays when a user taps the same header twice in under 300ms. (see Callbacks for more details)
# header_tap_hold - callback for when user taps and holds on a header for this column, triggered in touch displays when a user taps and holds the same header for 1 second. (see Callbacks for more details)
# header_mouse_enter - callback for when the mouse pointer enters a column header (see Callbacks for more details)
# header_mouse_leave - callback for when the mouse pointer leaves a column header (see Callbacks for more details)
# header_mouse_over - callback for when the mouse pointer enters a column header or one of its child elements(see Callbacks for more details)
# header_mouse_out - callback for when the mouse pointer enters a column header or one of its child elements(see Callbacks for more details)
# header_mouse_move - callback for when the mouse pointer moves over a column header (see Callbacks for more details)
# header_mouse_down - callback for the left mouse button is pressed with the cursor over a column header (see Callbacks for more details)
# header_mouse_up - callback for the left mouse button is released with the cursor over a column header (see Callbacks for more details)
# header_tooltip - sets the on hover tooltip for the column header (see Formatting Data for more details)
# header_vertical - change the orientation of the column header to vertical (see Vertical Column Headers for more details)
# editable_title - allows the user to edit the header titles. (see Editable Column Titles for more details)
# title_formatter - formatter function for header title (see Formatting Data for more details)
# title_formatter_params - additional parameters you can pass to the header title formatter(see Formatting Data for more details)
# header_word_wrap - Allow word wrapping in the column header (see Header Text Wrapping for more details)
# header_filter - filtering of columns from elements in the header (see Header Filtering for more details)
# header_filter_placeholder - placeholder text for the header filter (see Header Filtering for more details)
# header_filter_params - additional parameters you can pass to the header filter (see Header Filtering for more details)
# header_filter_empty_check - function to check when the header filter is empty (see Header Filtering for more details)
# header_filter_func - the filter function that should be used by the header filter (see Header Filtering for more details)
# header_filter_func_params - additional parameters object passed to the headerFilterFunc function (see Header Filtering for more details)
# header_filter_live_filter - disable live filtering of the table (see Header Filtering for more details)
# header_menu - add menu button to column header (see Header Menus for more details)
# header_click_menu - add click menu to column header (see Header Menus for more details)
# header_dbl_click_menu - add double click menu to column header (see Header Menus for more details)
# header_context_menu - add context menu to column header (see Header Menus for more details)
# header_popup - add popup button to column header (see Column Header Popups for more details)
# header_click_popup - add click popup to column header (see Column Header Popups for more details)
# header_context_popup - add context popup to column header (see Column Header Popups for more details)

# nolint end
column_general_params <- c("title", "field", "visible")
column_layout_params <- c(
  "hoz_align", "vert_align", "header_hoz_align", "width", "min_width",
  "max_width", "max_initial_width", "width_grow", "width_shrink", "resizable",
  "frozen", "responsive", "tooltip", "css_class", "row_handle", "html_output",
  "print", "clipboard"
)

column_header_params <- c(
  "headerSort", "headerSortStartingDir", "headerSortTristate",
  "headerClick", "headerDblClick", "headerContext", "headerTap",
  "headerDblTap", "headerTapHold", "headerMouseEnter",
  "headerMouseLeave", "headerMouseOver", "headerMouseOut",
  "headerMouseMove", "headerMouseDown", "headerMouseUp",
  "headerTooltip", "headerVertical", "editableTitle", "titleFormatter",
  "titleFormatterParams", "headerWordWrap", "headerFilter",
  "headerFilterPlaceholder", "headerFilterParams",
  "headerFilterEmptyCheck", "headerFilterFunc", "headerFilterFuncParams",
  "headerFilterLiveFilter", "headerMenu", "headerClickMenu",
  "headerDblClickMenu", "headerContextMenu", "headerPopup",
  "headerClickPopup", "headerContextPopup"
)

#' Set the columns for a tabulator object
#' @param tabulator_object A tabulator object
#' @param columns A list of columns
#' @export
tabulator_columns <- function(tabulator_object, columns) {
  tabulator_object$x$columns <- columns
  tabulator_object
}

#' Tabulator column constructor
#' See https://tabulator.info/docs/6.2/columns#definition for more details.
#' @param ... Named arguments to be passed to the column.
#' @export
tabulator_column <- function(...) {
  assert_valid_params(...)
  list(...)
}

assert_valid_params <- function(...) {
  TRUE
}
