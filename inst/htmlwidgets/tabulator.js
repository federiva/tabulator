HTMLWidgets.widget({

  name: 'tabulator',

  type: 'output',

  factory: function(el, width, height) {

    let table = null;

    return {
      getTable: function() {
        return table
      },

      renderValue: function(x) {
        // TODO: look for an old table and destroy it before re rendering
        console.log("rendering poni")
        window.la = el;
        window.da = x;
        if (!!x.table_options.spreadsheet) {
          console.log("rendering spreadsheet")
          table = new Tabulator(`#${el.id}`, {
            spreadsheetData: !!x.data ? x.data : null,
            ...parseTableOptions(x, ["data"]),
          })
        } else {
          console.log("rendering")
          table = new Tabulator(`#${el.id}`, {
            data: x.data,
            layout: x.column_layout_mode,
            filterMode: "remote", // TODO Remove this default
            layoutColumnsOnNewData: x.layout_columns_on_new_data,
            ...parseTableOptions(x),
            ...parsePagination(x),
            ...parseColumns(x),
            ...parseSortMode(x),
          });
        }
        if (!!window.Shiny) {
          subscribeTableEvents(x, el.id, table);
          subscribeDefaultEvents(table);
        }
        window.pala = table;
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
    autoColumns: !!serializedData.columns ? false : true,
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
  console.log('parsing columns')
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

const parseTableOptions = (x, toRemove = null) => {
  if (!!toRemove) {
    // remove the toremove options
    toRemove.forEach(option => {
      delete x.table_options[option]
    })
  }
  return x.table_options
}

removeCSSDependencies = (params) => {
  $("head link[href*='tabulator-htmlwidgets-css']").remove();
}

if (!!window.Shiny) {
  Shiny.addCustomMessageHandler("remove_css_dependencies", removeCSSDependencies);
}
