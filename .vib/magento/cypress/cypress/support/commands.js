/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

const COMMAND_DELAY = 2000;
const BASE_URL = 'http://magento.my';

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

for (const query of ['get']) {
  Cypress.Commands.overwriteQuery(query, function (originalFn, ...args) {
    const innerFn = originalFn.apply(this, args.concat({timeout: COMMAND_DELAY}))

    return (subject) => {
      return innerFn(subject)
    }
  })
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
  (username = Cypress.env('username'), password = Cypress.env('password')) => {
    cy.visit('/admin');
    cy.get('#username').type(username);
    cy.get('#login').type(password);
    cy.contains('Sign in').click();

    // It takes some time for the full page to render
    cy.get('.spinner',  {timeout: 15000}).should('not.be.visible');
    cy.contains('.page-title', 'Dashboard');

    // First time we log in, a pop-up to allow data collection is shown
    cy.get('body').then(($body) => {
      if ($body.text().includes('Allow Adobe')) {
        cy.get('aside.modal-popup').within(() => {
          cy.contains("Allow").click();
        })
      }
    });
  }
);

Cypress.Commands.add('logout', () => {
  cy.get('[title="My Account"]').click();
  cy.contains('Sign Out').click();
});

Cypress.on('uncaught:exception', (err, runnable) => {
  // we expect an application error with message 'rendering locks'
  // or 'define is not defined; and don't want to fail the test,
  // so we return false
  if (err.message.includes('renderingLocks') || err.message.includes('define is not defined')) {
    return false;
  }
  // we still want to ensure there are no other unexpected
  // errors, so we let them fail the test
});
