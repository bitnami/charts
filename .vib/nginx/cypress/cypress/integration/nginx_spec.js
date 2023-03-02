/// <reference types="cypress" />

it('can access welcome page', () => {
  cy.visit('/');
  cy.contains('Welcome to nginx');
});