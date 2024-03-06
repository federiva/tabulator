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
      tabulatorTable.on(eventName, getEventCallback(tableId, eventName))
    })
  }
}

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

const cellEventsTypes = {
  eventCellEvents: [
    "cellClick", "cellDblClick", "cellContext", "cellTap", "cellDblTap", "cellTapHold",
    "cellMouseEnter", "cellMouseLeave", "cellMouseOver", "cellMouseOut", "cellMouseMove",
    "cellMouseDown", "cellMouseUp",
  ]
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
      window.cell = cell;
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
  }
  return callback
}
