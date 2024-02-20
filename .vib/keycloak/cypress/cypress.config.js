module.exports = {
  pageLoadTimeout: 240000,
  defaultCommandTimeout: 90000,
  viewportWidth: 1920,
  viewportHeight: 1080,
  env: {
    username: 'user',
    password: 'ComplicatedPassword123!4',
  },
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost',
  },
}
