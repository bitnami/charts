/*
 * Copyright VMware, Inc.
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
    cy.visit('/jasperserver/login.html');
    cy.get('#j_username').click().type(username);
    cy.get('#j_password_pseudo').click().type(password);
    cy.get('#submitButton').click();

    // The login process completes when the directory tree is fully loaded
    cy.get('#folders').within(() => {
      cy.contains('root');
    });
    cy.get('body').then(($body) => {
      // Close the pop-up if appears
      if ($body.find('#heartbeatOptin').is(':visible')) {
        cy.get('#heartbeatOptin').within(() => {
          cy.contains('button', 'OK').click();
        });
      }
    });
  }
);
