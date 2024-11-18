module.exports = {
  defaultCommandTimeout: 30000,
  env: {
    expectedWorkers: 2,
  },
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost/',
  },
}
