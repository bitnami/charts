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

Cypress.Commands.add('login', () => {
  cy.request('/static/token/token.txt').then(res => {
    cy.visit('/login');
    cy.get('#token').type(res.body);
    cy.contains('Submit').click();
  })
});

Cypress.on('uncaught:exception', (err) => {
  // we expect a 3rd party library error with message 'ResizeObserver loop'
  // and don't want to fail the test so we return false
  if (err.message.includes("ResizeObserver loop")) {
    return false;
  }
  // we still want to ensure there are no other unexpected
  // errors, so we let them fail the test
})
