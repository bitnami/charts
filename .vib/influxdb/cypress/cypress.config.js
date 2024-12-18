module.exports = {
  env: {
    username: 'influxAdmin',
    password: 'RootP4ssw0rd',
    bucket: 'primary',
    org: 'primary',
  },
  defaultCommandTimeout: 30000,
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost',
  },
}
