module.exports = {
  chromeWebSecurity: false,
  hosts: {
    'vmware-oauth2-proxy.my': '{{TARGET_IP}}',
  },
  env: {
    upstreamURL: '/bitnami/oauth2-proxy/conf/',
    upstreamContent: 'oauth2_proxy.cfg',
    dexPort: '5556',
  },
  e2e: {
    setupNodeEvents(on, config) {},
  },
}
