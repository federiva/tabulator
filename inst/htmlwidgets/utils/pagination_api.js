/**
 * Automatically sets the filterMode Tabulator's option to remote if the paginationMode is remote
 * @param {Object} serializedData - The serialized data object
 * @returns {string|null} The filterMode Tabulator's option
 */
const autoFilterMode = serializedData => {
  if (serializedData.paginationMode === "remote") {
    shinyTabulatorLog("Setting automatically filterMode Tabulator's option to remote");
    return "remote";
  } else {
    return null;
  }
}

/**
 * Automatically sets the layoutColumnsOnNewData Tabulator's option to true if the paginationMode is remote or server
 * @param {Object} serializedData - The serialized data object
 * @returns {boolean|null} The layoutColumnsOnNewData Tabulator's option
 */
const autoLayoutColumnsOnNewData = serializedData => {
  if (["remote", "server"].includes(serializedData.paginationMode)) {
    shinyTabulatorLog("Setting automatically layoutColumnsOnNewData Tabulator's option to true");
    return true;
  } else {
    return null;
  }
}

/**
 * Parses the pagination data and returns the pagination options
 * @param {Object} serializedData - The serialized data object
 * @returns {Object} The pagination options
 */
const parsePagination = serializedData => {
  return {
    autoColumns: !!serializedData.columns ? false : true,
    pagination: serializedData.pagination,
    paginationMode: serializedData.paginationMode,
    filterMode: autoFilterMode(serializedData),
    layoutColumnsOnNewData: autoLayoutColumnsOnNewData(serializedData),
    ajaxURL: serializedData.ajaxURL,
    ajaxParams: serializedData.ajaxParams,
    paginationSize: serializedData.paginationSize,
    paginationInitialPage: serializedData.paginationInitialPage
  }
}