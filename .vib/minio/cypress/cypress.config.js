module.exports = {
  env: {
    username: 'test_admin',
    password: 'ComplicatedPassword123!4',
  },
  defaultCommandTimeout: 30000,
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost/',
  },
}
