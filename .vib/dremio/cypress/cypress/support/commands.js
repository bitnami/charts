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
     cy.get('#userName').should('be.enabled').clear({force: true}).type(username);
     cy.get('#password').should('be.enabled').clear({force: true}).type(password);
     cy.contains('Log In').click();
     cy.contains('Datasets');
   }
);

Cypress.on('uncaught:exception', (err) => {
  if (err.message.includes('Cannot read properties of')) {
    return false;
  }
  if (err.message.includes('Normalize accepts')) {
    return false;
  }
  // We expect an error "Failed to execute 'observe' on 'IntersectionObserver'"
  // during the installation of a template so we add an exception
  if (err.message.includes("Failed to execute 'observe' on 'IntersectionObserver'")) {
    return false;
  }

  // we still want to ensure there are no other unexpected
  // errors, so we let them fail the test
})
