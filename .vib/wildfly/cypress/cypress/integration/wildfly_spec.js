/// <reference types="cypress" />

it('renders landing page correctly', () => {
  cy.visit('/');
  cy.contains('instance is running');
});
