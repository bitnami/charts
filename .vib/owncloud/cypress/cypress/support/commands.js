const COMMAND_DELAY = 800;
const BASE_URL = 'http://vmware-owncloud/';

Cypress.Commands.overwrite('visit', (originalFn, url, options) => {
  return originalFn(`${BASE_URL}${url}`, options);
});

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
    cy.clearCookies();
    cy.visit('/');
    cy.get('.v-align').should('exist').and('be.visible'); //This should is needed to ensure stability of the test
    cy.get('#user').type(username);
    cy.get('#password').type(password);
    cy.get('#submit').click();
    cy.get('body').then(($body) => {
      if ($body.text().includes('A safe home')) {
        cy.get('#closeWizard').click();
      }
    });
  }
);
