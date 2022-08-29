const COMMAND_DELAY = 2000;
const BASE_URL = 'http://bitnami-ghost.my';

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
    cy.visit('/ghost/');
    cy.get('input[type="email"]').should('be.enabled').type(email);
    cy.get('input[type="password"]').should('be.enabled').type(password);
    cy.contains('button', 'Sign in').click();
    // In Ghost, logging is not considered as completed until the Dashboard view
    // is visible. Navigating to any other site before that will lead to an error
    // 500
    cy.contains('Dashboard').should('be.visible');
  }
);

Cypress.on('uncaught:exception', (err, runnable) => {
  // we expect a 3rd party library error with message 'ember-concurrency'
  // and don't want to fail the test so we return false
  if (
    err.message.includes('ember-concurrency') ||
    err.message.includes('Cannot read properties')
  ) {
    return false;
  }
  // we still want to ensure there are no other unexpected
  // errors, so we let them fail the test
});
