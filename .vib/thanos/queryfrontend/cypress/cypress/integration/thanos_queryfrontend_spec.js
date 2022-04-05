/// <reference types="cypress" />

it('allows to see runtime & build information', () => {
  cy.visit('/');
  cy.contains('.dropdown-toggle', 'Status').click();
  cy.contains('[class="dropdown-item"]', 'Runtime & Build Information').click();
  cy.contains('Runtime Information').should('be.visible');
  cy.get('h2').contains('Build Information').should('be.visible');
})

it('allows the execution of a query', () => {
  const QUERY_ALERT = 'No data queried yet';
  const QUERY_VALUE = 'vector(3000)';
  
  cy.visit('/graph');
  cy.get('.alert', QUERY_ALERT).contains(QUERY_ALERT);
  cy.get('.cm-line').type(QUERY_VALUE);
  cy.contains('.cm-completionLabel', QUERY_VALUE).click();
  cy.get('.execute-btn').click();
  cy.contains('.tab-content', QUERY_VALUE);
})

it('allows listing all installed stores', () => {
  cy.visit('/');
  cy.contains('[class="nav-link"]', 'Stores').click();
  cy.get('[data-testid="endpoint"]').should('be.visible');
  cy.get('[data-testid="health"]').should('be.visible');
})

it('allows changing of the UI', () => {
  cy.visit('/');
  cy.contains('[class="nav-link"]', 'Classic UI').click();
  cy.contains('.nav-link', 'New UI').should('exist');
})

it('allows adding a graph', () => {
  cy.visit('/');
  cy.contains('button', 'Add Panel').should('be.visible').click();
  cy.get('.execute-btn').should('have.length', 2);
})
