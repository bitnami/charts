const CLICK_DELAY = 500;

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

Cypress.Commands.add(
  'login',
  (username = Cypress.env('username'), password = Cypress.env('password')) => {
    cy.visit('/administrator');
    cy.get("[name='username']").type(username);
    cy.get("[name='passwd']").type(password);
    cy.contains('Log in').click();
  }
);
