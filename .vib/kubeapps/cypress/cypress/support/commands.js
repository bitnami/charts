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

Cypress.Commands.add('login', () => {
  cy.request('/static/token/token.txt').then(res => {
    cy.visit('/login');
    cy.get('#token').type(res.body);
    cy.contains('Submit').click();
  })
});
