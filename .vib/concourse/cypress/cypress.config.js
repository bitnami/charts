module.exports = {
  env: {
    username: 'bitnamiUser',
    password: 'ComplicatedPassword123!4',
  },
  hosts: {
    'vmware-concourse.my': '{{ TARGET_IP }}',
  },
  e2e: {
    setupNodeEvents(on, config) {},
  },
}
