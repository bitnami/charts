/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

const COMMAND_DELAY = 2000;
const BASE_URL = 'http://vmware-prestashop.my';

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
  return originalFn(`${BASE_URL}${url}`, options);
});

Cypress.Commands.add(
  'login',
  (email = Cypress.env('email'), password = Cypress.env('password')) => {
    cy.visit('/administration/index.php');
    cy.get('#email').type(email);
    cy.get('#passwd').type(password);
    cy.get('#submit_login').click();
    cy.contains('Dashboard');
  }
);

Cypress.on('uncaught:exception', (err, runnable) => {
  if (
    err.message.includes('has already been declared') ||
    err.message.includes('NavbarTransitionHandler is not defined')
  ) {
    return false;
  }
  // we still want to ensure there are no other unexpected
  // errors, so we let them fail the test
});
