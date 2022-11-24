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
    cy.visit('/user/login');
    cy.get('input[name="user_name"]').should('be.enabled').type(username);
    cy.get('input[type="password"]').should('be.enabled').type(password);
    cy.contains('button', 'Sign In').click();
    cy.get('#navbar .avatar').should('be.visible');
  }
);
