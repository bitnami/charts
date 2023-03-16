module.exports = {
  defaultCommandTimeout: 30000,
  env: {
    username: 'tomcatUser',
    password: 'ComplicatedPassword123!4',
  },
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost',
  },
}
