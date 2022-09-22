/// <reference types="cypress" />

it('allows running a query', () => {
  cy.visit('/play');
  cy.get('#user').clear();
  cy.get('#user').type(Cypress.env('username'));
  cy.get('#password').type(Cypress.env('password'));
  cy.fixture('queries').then((queries) => {
    cy.get('#query').type(queries.dbQuery.query);
  });
  cy.get('#run').click();
  cy.fixture('queries').then((queries) => {
    cy.contains(queries.dbQuery.output.header);
    cy.contains(queries.dbQuery.output.return);
  });
});
