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
    cy.get('[id$="username"]').should('be.enabled').type(username);
    cy.get('[type="password"]').should('be.enabled').type(password);
    cy.contains('button', 'Login').click();
    cy.contains('Upstream').should('be.visible');
  }
);

Cypress.on('uncaught:exception', (err) => {
  // We expect an error "Failed to execute 'observe' on 'IntersectionObserver'"
  // during the installation of a template so we add an exception
  if (err.message.includes("Failed to execute 'observe' on 'IntersectionObserver'")) {
    return false;
  }
  // We expect an issue with a map object but it the operation does not fail because of
  // that
  if (err.message.includes("reading 'map'")) {
    return false;
  }

  // we still want to ensure there are no other unexpected
  // errors, so we let them fail the test
})
