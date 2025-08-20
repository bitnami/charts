module.exports = {
  env: {
    token: 'deadbeefdeadbeefdeadbeef',
  },
  defaultCommandTimeout: 30000,
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'https://localhost',
  },
  retries: 5
}
