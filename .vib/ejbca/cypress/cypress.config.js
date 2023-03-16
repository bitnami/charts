module.exports = {
  env: {
    username: 'bitnamiTest',
    password: 'ComplicatedPassword123!4',
    baseDN: 'UID=c-1CCXmPAsNWmZuDtQQ8FHl7tcVdjCiNTH,O=ExampleCA,C=SE',
  },
  e2e: {
    // We've imported your old cypress plugins here.
    // You may want to clean this up later by importing these.
    setupNodeEvents(on, config) {
      return require('./cypress/plugins/index.js')(on, config)
    },
    baseUrl: 'http://localhost',
  },
}
