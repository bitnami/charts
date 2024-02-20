module.exports = {
  defaultCommandTimeout: 60000,
  env: {
    storePort: '10903',
    receivePort: '10904',
  },
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost/',
  },
}
