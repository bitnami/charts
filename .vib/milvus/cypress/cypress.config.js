module.exports = {
  env: {
    username: 'root',
    password: 'ComplicatedPassword123!4',
    host: 'milvus-proxy:80',
  },
  defaultCommandTimeout: 30000,
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost',
  },
}
