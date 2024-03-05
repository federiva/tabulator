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
      tabulatorTable.on(eventName, getColumnEventCallback(tableId, eventName))
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

/**
 * Get the event callback for a specific table and event name.
 *
 * @param {string} tableId - The ID of the table
 * @param {string} eventName - The name of the event
 * @return {any} The event callback function
 */
const getColumnEventCallback  = (tableId, eventName) => {
  let callback;
  if (columnEventsTypes.eventColumnEvents.includes(eventName)) {
    callback = columnEventCallbacks.eventColumnCallback(tableId, eventName)
  } else if (columnEventsTypes.columnColumnEvents.includes(eventName)) {
    callback = columnEventCallbacks.columnColumnCallback(tableId, eventName)
  } else if (columnEventsTypes.columnEvents.includes(eventName)) {
    callback = columnEventCallbacks.columnCallback(tableId, eventName)
  } else if (columnEventsTypes.columnVisibleEvents.includes(eventName)) {
    callback = columnEventCallbacks.columnVisibleCallback(tableId, eventName)
  }
  return callback
}
