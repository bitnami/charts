module.exports = {
  responseTimeout: 30000,
  env: {
    nodeNumber: 4,
  },
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'https://localhost',
  },
}
