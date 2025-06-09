module.exports = {
  pageLoadTimeout: 150000,
  defaultCommandTimeout: 90000,
  chromeWebSecurity: false,
  env: {
    replicaCount: '2',
  },
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost/',
  },
}
