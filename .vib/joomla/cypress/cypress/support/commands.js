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
    cy.visit('/administrator');
    cy.get("[name='username']").type(username);
    cy.get("[name='passwd']").type(password);
    cy.contains('Log in').click();
    cy.get('body').then(($body) => {
      // Close welcome tutorial pop-up if present
      if ($body.find('button.shepherd-cancel-icon').is(':visible')) {
        cy.get('button.shepherd-cancel-icon').click();
        // Reload the page for the backend to process the previous action
        cy.wait(1000);
        cy.reload();
      } else {
        cy.contains('Content');
      }
    });
  }
);
