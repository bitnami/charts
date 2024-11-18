module.exports = {
  env: {
    compactorReplicaCount: '2',
    distributorReplicaCount: '1',
    ingesterReplicaCount: '1',
    querierReplicaCount: '1',
    metricsReplicaCount: '1',
    gossipRingPort: '7946',
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
