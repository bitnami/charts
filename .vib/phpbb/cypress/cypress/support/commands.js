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
    // Using the specific URL results in random authentication errors
    cy.visit('/');
    cy.contains('Login').click();
    cy.get('#username').type(username);
    cy.get('#password').type(password);
    cy.get('[name=login]').click();
    // The authentication is not completed until the page is rendered
    cy.contains('Notifications');
  }
);
