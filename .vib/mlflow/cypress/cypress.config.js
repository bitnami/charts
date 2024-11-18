module.exports = {
  env: {
    username: 'vib-user',
    password: 'ComplicatedPassword123!4',
  },
  pageLoadTimeout: 240000,
  defaultCommandTimeout: 80000,
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost',
  },
}
