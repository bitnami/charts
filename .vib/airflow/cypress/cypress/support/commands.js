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

// Due to a bug when using "hosts" in Cypress, we cannot set a "baseUrl" in the
// cypress.json file. Workaround this by modifying the "visit" command to preprend
// the base URL.
//
// Further details: https://github.com/cypress-io/cypress/issues/20647
Cypress.Commands.overwrite('visit', (originalFn, url, options) => {
  // Only replace relative URLs
  const targetUrl = url.includes('://') ? url : `${Cypress.env('baseUrl')}${url}`;
  return originalFn(targetUrl, options);
});


Cypress.Commands.add(
  'login',
  (username = Cypress.env('username'), password = Cypress.env('password')) => {
    cy.visit('/');
    // Wait for DOM content to load
    cy.wait(5000);
    cy.get('form[name="login"]').should('exist').and('be.visible'); // Needed to ensure stability of the test
    cy.get('input#username').type(username);
    cy.get('input#password').type(password);
    cy.get('input[type="submit"]').click();
  }
);

Cypress.on('uncaught:exception', (err, runnable) => {
  // Skip all exceptions
  return false;
});
