module.exports = {
  env: {
    username: 'admin',
    password: 'ComplicatedPassword123!4',
  },
  defaultCommandTimeout: 30000,
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'https://localhost/',
  },
}
