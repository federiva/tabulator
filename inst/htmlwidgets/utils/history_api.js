//**
// * History API
// * Functions implementing interactions with the history of a tabulator table.
// * See https://tabulator.info/docs/6.0/history
// */


const undoAction = params => {
  const tableId = params.table_id;
  table = getTabulatorTable(tableId);
  table.undo();
};

const redoAction = params => {
  const tableId = params.table_id;
  table = getTabulatorTable(tableId);
  table.redo();
};

const clearHistory = params => {
  const tableId = params.table_id;
  table = getTabulatorTable(tableId);
  table.clearHistory();
};

Shiny.addCustomMessageHandler("undo_action", undoAction);
Shiny.addCustomMessageHandler("redo_action", redoAction);
Shiny.addCustomMessageHandler("clear_history", clearHistory)
