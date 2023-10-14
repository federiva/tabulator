HTMLWidgets.widget({

  name: 'tabulator',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        // TODO: code to render the widget, e.g.
        window.la = el;
        window.da = x;
        const table = new Tabulator(`#${el.id}`, {
          data: x.data,
          layout: x.column_layout_mode,
          filterMode: "remote",
          layoutColumnsOnNewData: x.layout_columns_on_new_data,
          ...parsePagination(x),
          ...parseColumns(x)
        });
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
    pagination: serializedData.pagination,
    paginationMode: serializedData.paginationMode,
    ajaxURL: serializedData.ajaxURL,
    ajaxParams: serializedData.ajaxParams,
    paginationSize: serializedData.paginationSize,
    paginationInitialPage: serializedData.paginationInitialPage
  }
}

const parseColumns = x => {
  return {
    autoColumns: !!x.columns ? false : true,
    columns: x.columns
  }
}