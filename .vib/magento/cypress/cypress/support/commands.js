const CLICK_DELAY = 1000;
const GET_DELAY = 1000;
const BASE_URL = 'http://vmware-magento.my';

for (const command of ['click']) {
  Cypress.Commands.overwrite(command, (originalFn, ...args) => {
    const origVal = originalFn(...args);

    return new Promise((resolve) => {
      setTimeout(() => {
        resolve(origVal);
      }, CLICK_DELAY);
    });
  });
}

for (const command of ['get']) {
  Cypress.Commands.overwrite(command, (originalFn, ...args) => {
    const origVal = originalFn(...args);

    return new Promise((resolve) => {
      setTimeout(() => {
        resolve(origVal);
      }, GET_DELAY);
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
  (username = Cypress.env('username'), password = Cypress.env('password')) => {
    cy.visit('/admin');
    cy.get('#username').type(username);
    cy.get('#login').type(password);
    cy.get('.action-login').click();
    cy.contains('.page-title', 'Dashboard');
  }
);

Cypress.Commands.add('logout', () => {
  cy.get('[title="My Account"]').click();
  cy.contains('Sign Out').click();
});

Cypress.on('uncaught:exception', (err, runnable) => {
  // we expect an application error with message 'rendering locks'
  // and don't want to fail the test so we return false
  if (err.message.includes('renderingLocks')) {
    return false;
  }
  // we still want to ensure there are no other unexpected
  // errors, so we let them fail the test
});
