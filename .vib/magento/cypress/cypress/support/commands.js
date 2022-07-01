const COMMAND_DELAY = 500;
const BASE_URL = 'http://vmware-magento.my';

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
  (username = Cypress.env('username'), password = Cypress.env('password')) => {
    cy.clearCookies();
    cy.visit('/admin');
    cy.get('.admin__legend');
    cy.get('#username').type(username);
    cy.get('#login').type(password);
    cy.get('.action-login').click();
    cy.get('body').then(($body) => {
      if ($body.text().includes('Allow Adobe to collect usage data')) {
        cy.get('.modal-header').should('be.visible');
        cy.contains('.action-primary', 'Allow').click();
      }
    });
    cy.get('.page-title').should('have.text', 'Dashboard');
  }
);
