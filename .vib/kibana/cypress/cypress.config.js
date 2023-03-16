module.exports = {
  pageLoadTimeout: 150000,
  defaultCommandTimeout: 50000,
  chromeWebSecurity: false,
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost/',
  },
}
