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
    // SolR stores user and session info in the Session Storage
    cy.window().then((win) => {
      win.sessionStorage.clear();
    });
    cy.visit('/solr/#/');
    cy.contains('Basic Authentication');
    cy.get('input#username').type(username);
    cy.get('input#password').type(password);
    cy.contains('button', 'Login').click();
  }
);
