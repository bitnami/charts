/// <reference types="cypress" />

export let random = (Math.random() + 1).toString(36).substring(7);

export let selectOrg = (org = Cypress.env('org')) => {
  cy.get('[data-testid="user-nav"]').click();
  cy.get('[data-testid="user-nav-item-switch-orgs"]').click();
  cy.contains('li', org).click();
  cy.contains('Getting Started');
};
