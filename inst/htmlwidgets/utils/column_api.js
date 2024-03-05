/**
 * Hides a column in a tabulator table by its field name.
 *
 * @param {Object} params - An object containing the table_id and field of the column to be hidden
 * @return {void}
 */
const hideColumnByField = (params) => {
  tableId = params.table_id;
  field = params.field;
  table = getTabulatorTable(tableId);
  table.getColumn(field).hide();
}

/**
 * Function to show a specific column in a tabulator table based on the field name.
 *
 * @param {object} params - An object containing the table ID and the field name
 * @return {void} No return value
 */
const showColumnByField = (params) => {
  tableId = params.table_id;
  field = params.field;
  table = getTabulatorTable(tableId);
  table.getColumn(field).show();
}

/**
 * Toggles the visibility of a column in a Tabulator table.
 *
 * @param {Object} params - An object containing the table_id and field for the column to be toggled.
 * @return {void} 
 */
const toggleColumnByField = (params) => {
  tableId = params.table_id;
  field = params.field;
  table = getTabulatorTable(tableId);
  table.getColumn(field).toggle();
}

// Shiny bindings
Shiny.addCustomMessageHandler("hide_column_by_field", hideColumnByField);
Shiny.addCustomMessageHandler("show_column_by_field", showColumnByField);
Shiny.addCustomMessageHandler("toggle_column_by_field", toggleColumnByField);
