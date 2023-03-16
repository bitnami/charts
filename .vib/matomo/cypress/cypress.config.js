module.exports = {
  env: {
    username: 'user',
    password: 'ComplicatedPassword123!4',
    email: 'user@example.com',
  },
  hosts: {
    'bitnami-matomo.my': '{{ TARGET_IP }}',
  },
  defaultCommandTimeout: 30000,
  e2e: {
    setupNodeEvents(on, config) {},
  },
}
