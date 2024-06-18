module.exports = {
  env: {
    username: 'user',
    password: 'ComplicatedPassword123!4',
    email: 'user@example.com',
    port: '80',
  },
  defaultCommandTimeout: 30000,
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost',
  },
}
