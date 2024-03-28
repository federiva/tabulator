const clearSheet = params => {
  const tableId = params.table_id;
  const sheetKey = params.key;
  const table = getTabulatorTable(tableId);
  table.clearSheet(sheetKey);
};

const addSheet = params => {
  const tableId = params.table_id;
  const sheetDefinition = params.sheet;
  const table = getTabulatorTable(tableId);
  table.addSheet(sheetDefinition);
};

if (!!window.Shiny) {
  Shiny.addCustomMessageHandler("clear_sheet", clearSheet);
  Shiny.addCustomMessageHandler("add_sheet", addSheet);
}
