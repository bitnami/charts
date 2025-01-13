module.exports = {
  defaultCommandTimeout: 30000,
  env: {
    username: 'test_user',
    password: 'ComplicatedPassword123!4',
  },
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost/',
  },
  retries: 5
}
