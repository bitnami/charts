/// <reference types="cypress" />

it('allows to see runtime & build information', () => {
    cy.visit('/');
    cy.contains('.dropdown-toggle', 'Status').click();
    cy.contains('[class="dropdown-item"]', 'Runtime & Build Information').click();
    cy.contains('Runtime Information');
    cy.contains('h2', 'Build Information');
    cy.contains('.capitalize-title', 'Version');
})

it('allows to see the Blocks page', () => {
    cy.visit('/');
    cy.get('.nav-link').contains('Blocks').click();
    cy.contains('No blocks found.');
})
