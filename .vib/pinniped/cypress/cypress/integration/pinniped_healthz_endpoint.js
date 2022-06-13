/// <reference types="cypress" />

it('healthz endpoint is available', () => {
  cy.request('/healthz');
  cy.contains('body', 'ok');
});
