module.exports = {
  pageLoadTimeout: 120000,
  defaultCommandTimeout: 30000,
  env: {
    username: 'test_admin',
    password: 'ComplicatedPassword123!4',
  },
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost/',
  },
}
