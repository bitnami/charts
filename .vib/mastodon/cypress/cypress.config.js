module.exports = {
  env: {
    username: 'vib-user@changeme.com',
    password: 'bitnami!1234',
  },
  hosts: {
    'bitnami-mastodon.my': '{{ TARGET_IP }}',
  },
  viewportWidth: 1920,
  viewportHeight: 1080,
  defaultCommandTimeout: 60000,
  e2e: {
    setupNodeEvents(on, config) {},
  },
}
