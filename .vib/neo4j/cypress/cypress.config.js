module.exports = {
  pageLoadTimeout: 240000,
  defaultCommandTimeout: 80000,
  env: {
    username: 'neo4j',
    password: 'ComplicatedPassword123!4',
  },
  hosts: {
    'bitnami-neo4j.my': '{{ TARGET_IP }}',
  },
  e2e: {
    setupNodeEvents(on, config) {},
  },
}
