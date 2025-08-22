module.exports = {
  env: {
    username: 'vibuser@example.com',
    password: 'bitnami!1234567',
  },
  defaultCommandTimeout: 60000,
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost',
  },
  retries: 5
}
