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

const removeSheet = params => {
  const tableId = params.table_id;
  const sheetKey = params.key;
  const table = getTabulatorTable(tableId);
  table.removeSheet(sheetKey);
}

if (!!window.Shiny) {
  Shiny.addCustomMessageHandler("clear_sheet", clearSheet);
  Shiny.addCustomMessageHandler("add_sheet", addSheet);
  Shiny.addCustomMessageHandler("remove_sheet", removeSheet);
}
