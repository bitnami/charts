/// <reference types="cypress" />

it('can access backend server', () => {
  cy.visit('/');
  cy.contains('Welcome to nginx')
});