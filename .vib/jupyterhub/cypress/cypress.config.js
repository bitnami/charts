module.exports = {
  defaultCommandTimeout: 30000,
  env: {
    username: 'test_user',
    password: 'BitnamiComplicatedPassword123!45678',
  },
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost/',
  },
  retries: 5
}
