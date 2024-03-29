module.exports = {
  env: {
    username: 'bitnamiTest',
    email: 'bitnamiTest@example.com',
    password: 'ComplicatedPassword123!4',
  },
  hosts: {
    'vmware-prestashop.my': '{{ TARGET_IP }}',
  },
  defaultCommandTimeout: 30000,
  viewportWidth: 1800,
  viewportHeight: 800,
  chromeWebSecurity: false,
  e2e: {
    setupNodeEvents(on, config) {},
  },
}
