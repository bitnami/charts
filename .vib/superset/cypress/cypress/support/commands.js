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
    cy.visit('/login');
    // Wait for DOM content to load
    cy.wait(5000);
    cy.get('form[name="login"]').should('exist').and('be.visible'); // Needed to ensure stability of the test
    cy.get('input#username').type(username);
    cy.get('input#password').type(password);
    cy.get('input[type="submit"]').click();
  }
);
