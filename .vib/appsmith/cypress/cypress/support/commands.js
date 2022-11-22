const COMMAND_DELAY = 2000;
const BASE_URL = 'http://bitnami-appsmith.my';

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
    cy.visit('/');
    cy.get('input[type="email"]').should('be.enabled').type(email);
    cy.get('input[type="password"]').should('be.enabled').type(password);
    cy.contains('button', 'sign in').click();
    cy.contains('WORKSPACES').should('be.visible');
  }
);
