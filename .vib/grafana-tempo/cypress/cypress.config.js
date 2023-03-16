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
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost',
  },
}
