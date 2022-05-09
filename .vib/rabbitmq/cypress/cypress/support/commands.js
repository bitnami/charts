const COMMAND_DELAY = 600;

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
    cy.visit('/');
    cy.get('[alt="RabbitMQ logo"]');
    cy.get('[name="username"]').type(username);
    cy.get('[name="password"]').type(password);
    cy.contains('Login').click();
  }
);
