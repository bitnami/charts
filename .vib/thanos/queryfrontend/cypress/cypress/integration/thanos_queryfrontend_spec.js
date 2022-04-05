/// <reference types="cypress" />

it('allows to see runtime & build information', () => {
  cy.visit('/');
  cy.contains('.dropdown-toggle', 'Status').click();
  cy.contains('[class="dropdown-item"]', 'Runtime & Build Information').click();
  cy.contains('Runtime Information');
  cy.contains('h2', 'Build Information');
  cy.contains('.capitalize-title','Version');
})

it('allows the execution of a query', () => {
  const QUERY_ALERT = 'No data queried yet';
  const QUERY_KEYWORD = 'vector';
  const QUERY_VALUE = '3000';
  
  cy.visit('/graph');
  cy.contains('.alert', QUERY_ALERT);
  cy.get('.cm-line').type(QUERY_KEYWORD, '{enter}').type(`(${QUERY_VALUE})`).click();
  cy.get('.execute-btn').click();
  cy.contains('.tab-content', QUERY_VALUE);
})

it('allows listing all installed stores', () => {
  cy.visit('/');
  cy.contains('[class="nav-link"]', 'Stores').click();
  cy.get('[data-testid="endpoint"]').should('be.visible');
  cy.get('[data-testid="health"]').contains('UP');
  cy.get('.badge-success').should('exist');
})

it('allows adding a graph', () => {
  cy.visit('/');
  cy.contains('button', 'Add Panel').should('be.visible').click();
  cy.get('.execute-btn').should('have.length', 2);
})
