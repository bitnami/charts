/// <reference types="cypress" />

it('renders application correctly', () => {
  cy.visit('/');
  cy.contains('This is your to do list');
});