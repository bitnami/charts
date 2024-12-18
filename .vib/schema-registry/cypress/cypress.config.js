module.exports = {
  responseTimeout: 30000,
  env: {
    compatibilityLevel: 'BACKWARD',
  },
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost',
  },
}
