const copyTable = params => {
  const tableId = params.table_id;
  const what = params.what;
  const table = getTabulatorTable(tableId);
  table.copyToClipboard(what);
}

if (!!window.Shiny) {
  Shiny.addCustomMessageHandler("copy_table", copyTable);
}
