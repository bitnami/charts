/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

const COMMAND_DELAY = 2000;
const BASE_URL = 'http://bitnami-discourse.my';

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

Cypress.Commands.overwrite('visit', (originalFn, url, options) => {
  return originalFn(`${BASE_URL}${url}`, options);
});

Cypress.Commands.add(
  'login',
  (username = Cypress.env('username'), password = Cypress.env('password')) => {
    cy.visit('/');
    cy.contains('button', 'Log In').click();
    cy.get('#login-account-name').type(username);
    cy.get('#login-account-password').type(`${password}{enter}`);

    // In Discourse, logging is not considered as completed until the home page is visible.
    // Navigating to any other site before that will lead to a 404 error
    cy.contains('a', 'Unread');
    // First time login shows a welcome popup
    cy.get('body').then(($body) => {
      if ($body.text().includes('Got it')) {
        cy.contains('Got it').click();
      }
    });
    // A "Your first notification" popup will also show
    cy.get('body').then(($body) => {
      if ($body.text().includes('Got it')) {
        cy.contains('Got it').click();
      }
    });
  }
);
