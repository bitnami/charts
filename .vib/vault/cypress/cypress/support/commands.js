/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

const COMMAND_DELAY = 2000;

for (const command of ['click']) {
  Cypress.Commands.overwrite(command, (originalFn, ...args) => {
    const origVal = originalFn(...args);

    return new Promise((resolve) => {
      setTimeout(() => {
        resolve(origVal);
      }, COMMAND_DELAY);
    });
  });
}

Cypress.Commands.add(
  'login',
  (username = Cypress.env('username'), password = Cypress.env('password')) => {
    cy.visit('/');
    cy.get('select.select').select('userpass');
    cy.get('#username').should('be.enabled').type(username);
    cy.get('#password').should('be.enabled').type(password);
    cy.contains('button', 'Sign in').click();
    cy.contains('Secrets engines').should('be.visible');
  }
);

Cypress.on('uncaught:exception', (err) => {
  // We expect an error "Failed to execute 'observe' on 'IntersectionObserver'"
  // during the installation of a template so we add an exception
  if (err.message.includes("Failed to execute 'observe' on 'IntersectionObserver'")) {
    return false;
  }
  // we still want to ensure there are no other unexpected
  // errors, so we let them fail the test
})
