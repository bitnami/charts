module.exports = {
  viewportWidth: 1920,
  viewportHeight: 1080,
  env: {
    username: 'vib-user',
    password: 'ComplicatedPassword123!4',
  },
  defaultCommandTimeout: 30000,
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost',
  },
}
