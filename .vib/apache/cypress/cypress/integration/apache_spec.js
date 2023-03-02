/// <reference types="cypress" />

it('visits the apache start page', () => {
  cy.visit('/');
  cy.contains('It works');
});

