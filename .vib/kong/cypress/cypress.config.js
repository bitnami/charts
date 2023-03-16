module.exports = {
  env: {
    apikey: 'ComplicatedPassword123!4',
    ingressHost: 'www.example.com',
    ingressPath: '/nginx',
    adminHttpPort: '443',
  },
  e2e: {
    setupNodeEvents(on, config) {},
    baseUrl: 'http://{{ TARGET_IP }}',
  },
}
