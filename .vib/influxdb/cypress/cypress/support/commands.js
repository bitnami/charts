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

Cypress.Commands.add('visitInOrg', (url) => {
  // Retrieve current organization and use it to navigate
  cy.url().then((currentUrl) => {
    expect(currentUrl).to.contain('orgs');
    const org = currentUrl.match(/orgs\/(\w*)/)[1];
    const path = url.startsWith('/') ? url : `/${url}`;
    cy.visit(`/orgs/${org}${path}`);
  });
});

Cypress.Commands.add(
  'login',
  (username = Cypress.env('username'), password = Cypress.env('password')) => {
    cy.visit('/signin');
    cy.get('[data-testid="username"]').should('be.enabled').type(username);
    cy.get('[data-testid="password"]').should('be.enabled').type(`${password}{enter}`);
    // The login process is not considered as completed until the UI is rendered
    cy.get('[data-testid="user-nav"]');
  }
);
