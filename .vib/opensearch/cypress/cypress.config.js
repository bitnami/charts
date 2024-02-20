module.exports = {
  responseTimeout: 30000,
  env: {
    nodeNumber: 5,
  },
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost',
  },
}
