module.exports = {
  env: {
    email: 'user@example.com',
    password: 'ComplicatedPassword123!4',
  },
  defaultCommandTimeout: 70000,
  pageLoadTimeout: 300000,
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost/',
  },
}
