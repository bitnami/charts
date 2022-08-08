const COMMAND_DELAY = 2000;
const BASE_URL = 'http://vmware-prestashop.my';

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
    cy.visit('/administration/index.php');
    cy.get('input#email').type(email);
    cy.get('input#passwd').type(password);
    cy.get('button#submit_login').click();
    cy.get('div#error').should('not.exist');
    cy.contains('Dashboard');
    cy.get('body').then(($body) => {
      if (
        $body.find('button[class*="onboarding-button-shut-down"]').length > 0
      ) {
        cy.get('button[class*="onboarding-button-shut-down"]').click();
      }
    });
  }
);

Cypress.on('uncaught:exception', (err, runnable) => {
  if (
    err.message.includes('has already been declared') ||
    err.message.includes('NavbarTransitionHandler is not defined')
  ) {
    return false;
  }
  // we still want to ensure there are no other unexpected
  // errors, so we let them fail the test
});
