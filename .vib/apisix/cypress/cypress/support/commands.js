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
  (token = Cypress.env('token')) => {
    cy.visit('/ui');
    cy.get('label').contains('Admin Key');
    cy.get('input').should('be.enabled').type(token);
    cy.visit('/ui');
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
