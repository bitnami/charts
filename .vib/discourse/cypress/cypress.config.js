module.exports = {
  env: {
    username: 'user',
    password: 'ComplicatedPassword123!4',
  },
  hosts: {
    'bitnami-discourse.my': '{{ TARGET_IP }}',
  },
  defaultCommandTimeout: 30000,
  e2e: {
    setupNodeEvents(on, config) {},
  },
}
