/// <reference types="cypress" />

it('can access backend server', () => {
  // HAProxy-Intel is configured with an NGINX server deployed as a sidecar, which
  // plays the role of backend. Successful access to NGINX means HAProxy-Intel is
  // correctly routing!
  cy.visit('/');
  cy.contains('Welcome to nginx')
});