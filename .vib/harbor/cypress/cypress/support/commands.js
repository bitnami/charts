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
  'login',
  (username = Cypress.env('username'), password = Cypress.env('password')) => {
    cy.visit('/account/sign-in');
    cy.get('#login_username').type(username);
    cy.get('#login_password').type(password);
    cy.get('button[type="submit"]').should('not.be.disabled').click();
  }
);

Cypress.on('uncaught:exception', (err) => {
  // The following error is produced on the application side, and we want
  // to ignore it
  if (err.message.includes("Cannot read properties of null")) {
    return false;
  }
  // we still want to ensure there are no other unexpected
  // errors, so we let them fail the test
})