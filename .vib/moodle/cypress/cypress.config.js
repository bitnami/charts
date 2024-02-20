module.exports = {
  chromeWebSecurity: false,
  env: {
    username: 'test_user',
    password: 'ComplicatedPassword123!4',
  },
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost',
  },
}
