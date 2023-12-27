const { defineConfig } = require("cypress");

module.exports = defineConfig({
  projectId: "6r9ayw",
  chromeWebSecurity: false,
  e2e: {
    baseUrl: "http://localhost:9060",
  },
  retries: { runMode: 5, openMode: 5 },
});
