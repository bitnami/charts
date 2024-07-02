module.exports = {
  pageLoadTimeout: 240000,
  defaultCommandTimeout: 80000,
  env: {
    username: 'neo4j',
    password: 'ComplicatedPassword123!4',
  },
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost:7477',
  },
}
