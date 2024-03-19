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
  const tableId = params.table_id;
  const field = params.field;
  const table = getTabulatorTable(tableId);
  table.getColumn(field).show();
}

/**
 * Toggles the visibility of a column in a Tabulator table.
 *
 * @param {Object} params - An object containing the table_id and field for the column to be toggled.
 * @return {void}
 */
const toggleColumnByField = (params) => {
  const tableId = params.table_id;
  const field = params.field;
  const table = getTabulatorTable(tableId);
  table.getColumn(field).toggle();
}

const replaceColumnDefinitions = (params) => {
  const tableId = params.table_id;
  const columnDefinitions = params.columns;
  table = getTabulatorTable(tableId);
  table.setColumns(columnDefinitions);
}

const updateColumnDefinition = (params) => {
  const tableId = params.table_id;
  const field = params.field;
  const columnDefinition = params.column_definition;
  table = getTabulatorTable(tableId);
  table.getColumn(field).updateDefinition(columnDefinition);
}

const addColumn = params => {
  const tableId = params.table_id;
  const columnDefinition = params.column_definition;
  const before = params.before;
  const position = params.position;
  table = getTabulatorTable(tableId);
  table.addColumn(columnDefinition, before, position);
}

const deleteColumn = params => {
  const tableId = params.table_id;
  const field = params.field;
  table = getTabulatorTable(tableId);
  table.deleteColumn(field);
}

// Shiny bindings
if (!!window.Shiny) {
  Shiny.addCustomMessageHandler("hide_column_by_field", hideColumnByField);
  Shiny.addCustomMessageHandler("show_column_by_field", showColumnByField);
  Shiny.addCustomMessageHandler("toggle_column_by_field", toggleColumnByField);
  Shiny.addCustomMessageHandler("replace_column_definitions", replaceColumnDefinitions);
  Shiny.addCustomMessageHandler("update_column_definition", updateColumnDefinition);
  Shiny.addCustomMessageHandler("add_column", addColumn);
  Shiny.addCustomMessageHandler("delete_column", deleteColumn);
}
