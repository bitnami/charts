const COMMAND_DELAY = 2000;
const BASE_URL = 'http://vmware-owncloud.my';

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

Cypress.Commands.overwrite('visit', (originalFn, url, options) => {
  return originalFn(`${BASE_URL}${url}`, options);
});

Cypress.Commands.add(
  'login',
  (username = Cypress.env('username'), password = Cypress.env('password')) => {
    cy.visit('/');
    cy.get('.v-align');
    cy.get('#user').type(username);
    cy.get('#password').type(password);
    cy.get('#submit').click();
    cy.get('body').then(($body) => {
      if ($body.find('#closeWizard').length) {
        cy.get('#closeWizard').click();
      }
    });
  }
);
