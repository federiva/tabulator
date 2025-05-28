const ShinyTabulatorCollection = {};

const destroyTable = (id) => {
  if (!!ShinyTabulatorCollection[id]) {
    shinyTabulatorWarn(`Destroying table with id ${id}`);
    ShinyTabulatorCollection[id].destroy();
    delete ShinyTabulatorCollection[id];
  }
}

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
        destroyTable(el.id);
        window.tabulator_table = x;
        if (!!x.table_options.spreadsheet) {
          table = new Tabulator(`#${el.id}`, {
            spreadsheetData: !!x.data ? x.data : null,
            ...parseTableOptions(x, ["data"]),
          })
        } else {
          table = new Tabulator(`#${el.id}`, {
            data: x.data,
            layout: x.column_layout_mode,
            ...parseTableOptions(x),
            ...parsePagination(x),
            ...parseColumns(x),
            ...parseSortMode(x),
          });
        }
        if (!!window.Shiny) {
          subscribeTableEvents(x, el.id, table);
          subscribeDefaultEvents(table);
          ShinyTabulatorCollection[el.id] = table;
        }
        window.pala = table;
      },

      resize: function(width, height) {
        if (!!ShinyTabulatorCollection[el.id]) {
          ShinyTabulatorCollection[el.id].redraw();
        }
      }

    };
  }
});

const parseLayout = layoutObject => {

}


const parseColumns = x => {
  const isPaginationModeRemote = x.paginationMode === "remote";
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
