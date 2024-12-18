/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

const COMMAND_DELAY = 3000;

for (const command of ['click', 'type']) {
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
    cy.get('#login_form_login').type(username);
    cy.get('#login_form_password').type(password);
    cy.contains('input', 'Sign in').click();
  }
);

Cypress.on('uncaught:exception', (err) => {
  // we expect an error with message 'cannot call methods on liveWidget'
  // and don't want to fail the test so we return false
  if (
    err.message.includes('cannot call methods on liveWidget')
  ) {
    return false;
  }
  // we still want to ensure there are no other unexpected
  // errors, so we let them fail the test
});
