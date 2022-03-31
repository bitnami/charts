/// <reference types="cypress" />

it('allows to see runtime & build information', () => {
  cy.visit('/');
  cy.contains('.dropdown-toggle', 'Status').click();
  cy.contains('[class="dropdown-item"]', 'Runtime & Build Information').click();
  cy.contains('Runtime Information').should('be.visible');
  cy.get('h2').contains('Build Information').should('be.visible');
})

it('allows the execution of a query', () => {
  cy.visit('/graph');
  cy.get('.alert').contains('No data queried yet').should('be.visible');
  cy.get('.cm-line').type('scalar');
  cy.contains('.cm-completionLabel', 'scalar').click();
  cy.get('.execute-btn').click();
  cy.get('.alert').contains('Empty query result').should('be.visible');
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

it('can switch from dark to light mode', () => {
  cy.visit('/');
  cy.get('[title="Use light theme"]').should('not.be.disabled').click();
  cy.get('[class="bootstrap-dark"').should('not.exist');
})
