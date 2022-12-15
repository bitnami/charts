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

Cypress.on('uncaught:exception', (err, runnable) => {
  // In Grafana 9.3.0 the console throws a typeError with message
  //'Cannot read properties of undefined (reading 'eventTrackingNamespace')'.
  // An issue has been created:
  // https://github.com/grafana/grafana/issues/60377
  if (err.message.includes("Cannot read properties of undefined (reading 'eventTrackingNamespace')")) {
    return false
  }
})

Cypress.Commands.add(
  'login',
  (username = Cypress.env('username'), password = Cypress.env('password')) => {
    cy.clearCookies();
    cy.visit('/login');
    cy.get('[aria-label*="Username"]').type(username);
    cy.get('[aria-label*="Password"]').type(password);
    cy.contains('Log in').click();
    cy.contains('Home');
  }
);
