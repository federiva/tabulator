const getTabulatorTable = tableId => {
  return HTMLWidgets.find(`#${tableId}`).getTable();
};