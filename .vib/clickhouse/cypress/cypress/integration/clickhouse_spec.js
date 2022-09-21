/// <reference types="cypress" />

it('allows running a query', () => {
  cy.visit('/play')
  cy.get('input[type="password"]').type(Cypress.env('password'));
  cy.fixture('query').then((query) => {
    cy.get('#query').type(query.query);
  });
  cy.get('#run').click();
  cy.fixture('query').then((query) => {
    cy.contains(query.output.header);
    cy.contains(query.output.return);
  });
});
