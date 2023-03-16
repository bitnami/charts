module.exports = {
  pageLoadTimeout: 240000,
  defaultCommandTimeout: 60000,
  env: {
    datacenterName: 'datacenter1',
    replicaCount: '3',
  },
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost',
  },
}
