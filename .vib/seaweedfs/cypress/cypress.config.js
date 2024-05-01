module.exports = {
  defaultCommandTimeout: 60000,
  env: {
    masterPortHttp: '9333',
    masterPortGrpc: '19333',
    volumePortHttp: '8080',
    volumePortGrpc: '18080',
    filerPortHttp: '8888',
    filerPortGrpc: '18888',
    s3PortHttp: '8333',
    s3PortGrpc: '18333',
  },
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost',
  },
}
