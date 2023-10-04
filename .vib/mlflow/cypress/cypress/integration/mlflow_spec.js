/*
 * Copyright VMware, Inc.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('can login and access the experiment run', () => {
  cy.visit('#/experiments/0', {
    auth: {
      username: Cypress.env('username'),
      password: Cypress.env('password'),
    },
    failOnStatusCode: false,
  });
  // If the run was successfully executed, this button should exist
  cy.get('a[href*="runs"]').first().click();
  cy.fixture('scripts').then((script) => {
    cy.contains(script.script.title);
    cy.contains(script.script.modelFile);
  });
});
