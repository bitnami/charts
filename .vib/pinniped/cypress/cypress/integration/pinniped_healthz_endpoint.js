/// <reference types="cypress" />

it('healthz endpoint is available', () => {
  cy.visit('/healthz');
  cy.contains('body', 'ok');
});
