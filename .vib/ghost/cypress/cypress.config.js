module.exports = {
  env: {
    email: 'vim-tests@example.com',
    username: 'bitnamiTest',
    password: 'Complicated123!4',
  },
  hosts: {
    'vmware-ghost.my': '{{ TARGET_IP }}',
  },
  defaultCommandTimeout: 60000,
  e2e: {
    setupNodeEvents(on, config) {},
  },
}
