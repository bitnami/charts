module.exports = {
  env: {
    username: 'test_user',
    password: 'ComplicatedPassword123!4',
  },
  defaultCommandTimeout: 30000,
  chromeWebSecurity: false,
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost/',
  },
}
