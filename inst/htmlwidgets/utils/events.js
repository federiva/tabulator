/**
 * Subscribes to table events and attaches event callbacks.
 *
 * @param {Object} x - the object containing events to subscribe to
 * @param {string} tableId - the ID of the table
 * @param {Tabulator} tabulatorTable - the Tabulator table to subscribe events to
 */
const subscribeTableEvents = (x, tableId, tabulatorTable) => {
  if (!!x.events) {
    x.events.forEach(eventName => {
      const eventCallback = getEventCallback(tableId, eventName);
      tabulatorTable.on(eventName, eventCallback);
    })
  }
};

/**
 * Subscribes to default events of a Tabulator table and sets input values in Shiny.
 *
 * @param {Object} tabulatorTable - The Tabulator table instance.
 */
const subscribeDefaultEvents = (tabulatorTable) => {
  tabulatorTable.on("cellEditing", function(cell) {
    const cellData = {
      field: cell.getField(),
      initial_value: cell.getInitialValue(),
      old_value: cell.getOldValue(),
      new_value: cell.getValue(),
      row_position: cell.getRow().getPosition(),
    }
    Shiny.setInputValue(`${tabulatorTable.element.id}_editing`, cellData, { priority: "event" });
  });

  tabulatorTable.on("cellEdited", function(cell) {
    const cellData = {
      field: cell.getField(),
      initial_value: cell.getInitialValue(),
      old_value: cell.getOldValue(),
      new_value: cell.getValue(),
      row_position: cell.getRow().getPosition(),
    }
    Shiny.setInputValue(`${tabulatorTable.element.id}_edited`, cellData, { priority: "event" });
  });

  // After rendering, bind all of the shiny inputs associated to this instance,
  // if any.
  tabulatorTable.on("tableBuilt", function() {
    Shiny.bindAll(document.getElementById(tabulatorTable.element.id));
  });

};

// Column events that can be subscribed
const columnEventsTypes = {
  eventColumnEvents : [
    "headerClick", "headerDblClick", "headerContext", "headerTap", "headerDblTap",
    "headerTapHold", "headerMouseEnter", "headerMouseLeave", "headerMouseOver",
    "headerMouseOut", "headerMouseMove", "headerMouseDown", "headerMouseUp",
  ],
  columnColumnEvents : ["columnMoved",],
  columnEvents : ["columnResized", "columnTitleChanged",],
  columnVisibleEvents : ["columnVisibilityChanged",],
}

const rowEventsTypes = {
  eventRowEvents: [
    "rowClick", "rowDblClick", "rowContext", "rowTap", "rowDblTap", "rowTapHold",
    "rowMouseEnter", "rowMouseLeave", "rowMouseOver", "rowMouseOut", "rowMouseMove",
    "rowMouseDown", "rowMouseUp",
  ],
  rowEvents: ["rowAdded", "rowUpdated", "rowDeleted", "rowResized", ]
}

const spreadsheetEventsTypes = {
  eventSpreadsheetEvents: [
    "sheetAdded", "sheetRemoved", "sheetLoaded", "sheetUpdated",
  ]
}

const cellEventsTypes = {
  eventCellEvents: [
    "cellClick", "cellDblClick", "cellContext", "cellTap", "cellDblTap", "cellTapHold",
    "cellMouseEnter", "cellMouseLeave", "cellMouseOver", "cellMouseOut", "cellMouseMove",
    "cellMouseDown", "cellMouseUp",
  ]
}

const validationEventsTypes = {
  eventCellEvents: ["validationFailed", ],
};

const spreadsheetEventCallbacks = {
  sheetCallback: (tableId, eventName) => {
    return function(sheet) {
      const inputId = `${tableId}_${eventName}`;
      window.lasheet = sheet;
      const dataEvent = {
        event: eventName,
        sheet_key: sheet.getKey(),
        sheet_name: sheet.getTitle()
      }
      Shiny.setInputValue(inputId, dataEvent, { priority: "event" });
    }
  }
}

// Column callbacks that are passed to each event
const columnEventCallbacks = {
  eventColumnCallback : (tableId, eventName) => {
    return function(e, column) {
      const inputId = `${tableId}_${eventName}`;
      Shiny.setInputValue(
        inputId,
        {
          event: eventName,
          field: column.getField(),
          col_values: column.getCells().map(x => x.getValue())
        },
        { priority: "event" }
      );
    }
  },
  columnColumnCallback: (tableId, eventName) => {
    return function(column, columns) {
      const inputId = `${tableId}_${eventName}`;
      Shiny.setInputValue(
        inputId,
        {
          event: eventName,
          field: column.getField(),
          col_values: column.getCells().map(x => x.getValue()),
          cols_order: columns.map(x => x.getField())
        },
        { priority: "event" }
      );
    }
  },
  columnCallback: (tableId, eventName) => {
    return function(column) {
      const inputId = `${tableId}_${eventName}`;
      Shiny.setInputValue(
        inputId,
        {
          event: eventName,
          field: column.getField(),
          col_values: column.getCells().map(x => x.getValue())
        },
        { priority: "event" }
      );
    }
  },
  columnVisibleCallback: (tableId, eventName) => {
    return function(column, visible) {
      const inputId = `${tableId}_${eventName}`;
      Shiny.setInputValue(
        inputId,
        {
          event: eventName,
          field: column.getField(),
          col_values: column.getCells().map(x => x.getValue()),
          visible: visible
        },
        { priority: "event" }
      );
    }
  },
}

const rowEventCallbacks = {
  eventRowCallback: (tableId, eventName) => {
    return function(e, row) {
      const inputId = `${tableId}_${eventName}`;
      Shiny.setInputValue(
        inputId,
        {
          event: eventName,
          position: row.getPosition(),
          row_data: row.getData(),
        },
        { priority: "event" }
      );
    }
  },
  rowCallback: (tableId, eventName) => {
    return function(row) {
      const inputId = `${tableId}_${eventName}`;
      Shiny.setInputValue(
        inputId,
        {
          event: eventName,
          row_position: row.getPosition(),
          row_data: row.getData(),
        },
        { priority: "event" }
      );
    }
  },
}

const cellEventCallbacks = {
  cellEventCallback: (tableId, eventName) => {
    return function(e, cell) {
      const inputId = `${tableId}_${eventName}`;
      Shiny.setInputValue(
        inputId,
        {
          event: eventName,
          value: cell.getValue(),
          field: cell.getColumn().getField(),
          row_position: cell.getRow().getPosition()
        },
        { priority: "event" }
      );
    }
  }
}

const validationEventCallbacks = {
  /**
   * A function that handles a validation event callback.
   *
   * @param {string} tableId - the ID of the table
   * @param {string} eventName - the name of the event
   * @return {function} a function that takes cell, value, and validators as parameters
   */
  validationEventCallback: (tableId, eventName) => {
    return function(cell, value, validators) {
      const inputId = `${tableId}_${eventName}`;
      Shiny.setInputValue(
        inputId,
        {
          event: eventName,
          value: value,
          field: cell.getColumn().getField(),
          row_position: cell.getRow().getPosition(),
          validators: validators
        },
        { priority: "event" }
      );
    }
  }
}


/**
 * Get the event callback for a specific table and event name.
 *
 * @param {string} tableId - The ID of the table
 * @param {string} eventName - The name of the event
 * @return {any} The event callback function
 */
const getEventCallback  = (tableId, eventName) => {
  let callback;
  if (columnEventsTypes.eventColumnEvents.includes(eventName)) {
    callback = columnEventCallbacks.eventColumnCallback(tableId, eventName)
  } else if (columnEventsTypes.columnColumnEvents.includes(eventName)) {
    callback = columnEventCallbacks.columnColumnCallback(tableId, eventName)
  } else if (columnEventsTypes.columnEvents.includes(eventName)) {
    callback = columnEventCallbacks.columnCallback(tableId, eventName)
  } else if (columnEventsTypes.columnVisibleEvents.includes(eventName)) {
    callback = columnEventCallbacks.columnVisibleCallback(tableId, eventName)
  } else if (rowEventsTypes.eventRowEvents.includes(eventName)) {
    callback = rowEventCallbacks.eventRowCallback(tableId, eventName)
  } else if (rowEventsTypes.rowEvents.includes(eventName)) {
    callback = rowEventCallbacks.rowCallback(tableId, eventName)
  } else if (cellEventsTypes.eventCellEvents.includes(eventName)) {
    callback = cellEventCallbacks.cellEventCallback(tableId, eventName)
  } else if (spreadsheetEventsTypes.eventSpreadsheetEvents.includes(eventName)) {
    callback = spreadsheetEventCallbacks.sheetCallback(tableId, eventName)
  } else if (validationEventsTypes.eventCellEvents.includes(eventName)) {
    callback = validationEventCallbacks.validationEventCallback(tableId, eventName)
  }
  return callback
}
