/// <reference types="cypress" />

it('allows to see runtime & build information', () => {
  cy.visit('/');
  cy.contains('.dropdown-toggle', 'Status').click();
  cy.contains('[class="dropdown-item"]', 'Runtime & Build Information').click();
  cy.contains('Runtime Information');
  cy.get('h2').contains('Build Information');
  cy.contains('.capitalize-title', 'version').siblings().should('not.be.empty'); //check if there is value for app and Go Version
  cy.contains('.capitalize-title', 'goVersion')
    .siblings()
    .should('not.be.empty');
});

it('allows to see the Blocks page', () => {
  cy.visit('/');
  cy.get('.nav-link').contains('Blocks').click();
  cy.contains('No blocks found.');
});
