HTMLWidgets.widget({

  name: 'tabulator',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        // TODO: look for an old table and destroy it before re rendering
        window.la = el;
        window.da = x;
        const table = new Tabulator(`#${el.id}`, {
          data: x.data,
          layout: x.column_layout_mode,
          filterMode: "remote", // TODO Remove this default
          nestedFieldSeparator: "..", // TODO Remove this default
          layoutColumnsOnNewData: x.layout_columns_on_new_data,
          ...parseTableOptions(x),
          ...parsePagination(x),
          ...parseColumns(x),
          ...parseSortMode(x),
        });
        window.pala = table;
        subscribeTableEvents(x, el.id, table);
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});

const parseLayout = layoutObject => {

}

const parsePagination = serializedData => {
  return {
    pagination: serializedData.pagination,
    paginationMode: serializedData.paginationMode,
    ajaxURL: serializedData.ajaxURL,
    ajaxParams: serializedData.ajaxParams,
    paginationSize: serializedData.paginationSize,
    paginationInitialPage: serializedData.paginationInitialPage
  }
}

const parseColumns = x => {
  const isPaginationModeRemote = x.paginationMode === "remote";
  console.log(isPaginationModeRemote)
  console.log((!isPaginationModeRemote && !!x.columns) ? x.columns : [])
  return {
    autoColumns: !!x.columns ? false : true,
    columns: (!isPaginationModeRemote || !!x.columns) ? x.columns ? x.columns : [] : []
  }
}

const parseSortMode = x => {
  const hasSortMode = !!x.sortMode;
  const isPaginationModeRemote = x.paginationMode === "remote";
  const statusSortMode = (hasSortMode || isPaginationModeRemote) ? "remote" : "local";
  return {
    sortMode: statusSortMode
  }
}

const parseTableOptions = x => {
  return x.table_options
}

const subscribeTableEvents = (x, tableId, tabulatorTable) => {
  if (!!x.events) {
    x.events.map(eventName => {
      console.log("registering " + eventName)
      tabulatorTable.on(eventName, getColumnEventCallback(tableId, eventName))
    })
  }
}


const eventColumnEvents = [
  "headerClick", "headerDblClick", "headerContext", "headerTap", "headerDblTap",
  "headerTapHold", "headerMouseEnter", "headerMouseLeave", "headerMouseOver",
  "headerMouseOut", "headerMouseMove", "headerMouseDown", "headerMouseUp",
]

const getColumnEventCallback  = (tableId, eventName) => {
  if (eventColumnEvents.includes(eventName)) {
    return eventColumnCallback(tableId, eventName)
  }
}

const eventColumnCallback = (tableId, eventName) => {
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
}
