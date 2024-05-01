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
  'visitAuth',
  (
    url,
    username = Cypress.env('username'),
    password = Cypress.env('password')
  ) => {
    const [protocol, host] = Cypress.config().baseUrl.split('://');
    const path = url.startsWith('/') ? url : `/${url}`;
    const basicAuthURL = `${protocol}://${username}:${password}@${host}${path}`;
    cy.visit(basicAuthURL);
  }
);
