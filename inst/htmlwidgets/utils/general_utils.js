const shinyTabulatorLog = (message) => {
  console.log(`%cShinyTabulator:%c ${message}`, "color: #49ad4a; font-weight: bold", "color: inherit");
};

const shinyTabulatorWarn = (message) => {
  console.warn(`%cShinyTabulator:%c ${message}`, "color: #ff9900; font-weight: bold", "color: inherit");
};

const shinyTabulatorError = (message) => {
  console.error(`%cShinyTabulator:%c ${message}`, "color: #ff0000; font-weight: bold", "color: inherit");
};
