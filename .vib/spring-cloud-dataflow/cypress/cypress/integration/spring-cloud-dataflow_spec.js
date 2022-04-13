/// <reference types="cypress" />

it('allows accesing the dashboard', () => {
  cy.visit('/');
  cy.get('.signpost-trigger').click();
  cy.get('.signpost-content-body').should('contain', 'Version');
});
