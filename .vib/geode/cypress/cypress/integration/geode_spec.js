/// <reference types="cypress" />

it('allows to login and display cluster health', () => {
  cy.login();
  cy.get('.normalStatus');
});
