module.exports = {
  env: {
    repoName: 'bitnami',
    repoURL: 'https://charts.bitnami.com/bitnami',
  },
  defaultCommandTimeout: 30000,
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://localhost/',
  },
}
