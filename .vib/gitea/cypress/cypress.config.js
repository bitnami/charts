module.exports = {
  env: {
    username: 'vib-user@example.com',
    password: 'bitnami!1234',
  },
  defaultCommandTimeout: 30000,
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost',
  },
}
