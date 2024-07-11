module.exports = {
  env: {
    username: 'vib_user',
    password: 'ComplicatedPassword!1234',
    postgresql_host: 'postgresql',
    postgresql_user: 'postgres',
    postgresql_db: 'vib_test',
    postgresql_password: 'password123',
  },
  defaultCommandTimeout: 30000,
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost',
  },
}
