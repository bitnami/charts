module.exports = {
  env: {
    username: 'vib-user',
    password: 'ComplicatedPassword123!4',
  },
  defaultCommandTimeout: 30000,
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'https://localhost',
  },
}
