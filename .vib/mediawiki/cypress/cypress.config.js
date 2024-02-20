module.exports = {
  env: {
    username: 'test_user',
    password: 'ComplicatedPassword123!4',
  },
  hosts: {
    'vmware-mediawiki.my': '{{ TARGET_IP }}',
  },
  defaultCommandTimeout: 30000,
  e2e: {
    setupNodeEvents(on, config) {},
  },
}
