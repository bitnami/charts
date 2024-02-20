module.exports = {
  env: {
    username: 'root',
    password: 'rootPassword',
  },
  defaultCommandTimeout: 30000,
  pageLoadTimeout: 240000,
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://34.133.95.121/',
  },
}
