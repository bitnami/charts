const { defineConfig } = require('cypress')

module.exports = defineConfig({
  pageLoadTimeout: 240000,
  defaultCommandTimeout: 90000,
  viewportWidth: 1920,
  viewportHeight: 1080,
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'https://localhost',
    supportFile: false,
  },
  component: {
    supportFile: false,
  },
})