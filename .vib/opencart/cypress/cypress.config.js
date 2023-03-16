module.exports = {
  env: {
    username: 'opencartUser',
    password: 'Password123!4',
  },
  hosts: {
    'vmware-opencart.my': '{{ TARGET_IP }}',
  },
  defaultCommandTimeout: 30000,
  e2e: {
    setupNodeEvents(on, config) {},
  },
}
