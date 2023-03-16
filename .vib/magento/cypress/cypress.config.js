module.exports = {
  env: {
    username: 'user',
    password: 'ComplicatedPassword123!4',
  },
  hosts: {
    'vmware-magento.my': '{{ TARGET_IP }}',
  },
  defaultCommandTimeout: 50000,
  pageLoadTimeout: 500000,
  e2e: {
    setupNodeEvents(on, config) {},
  },
}
