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
    cy.visit('/user/login');
    cy.get('#edit-name').type(username);
    cy.get('#edit-pass').type(password);
    cy.contains('input', 'Log in').click();
  }
);

Cypress.on('uncaught:exception', (err) => {
  // we expect an error with message 'Cannot read properties of undefined (reading 'nodeType')'
  // and don't want to fail the test so we return false
  if (
    err.message.includes('Cannot read properties')
  ) {
    return false;
  }
  // we still want to ensure there are no other unexpected
  // errors, so we let them fail the test
});
