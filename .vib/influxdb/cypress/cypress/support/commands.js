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

Cypress.Commands.add('visitInOrg', (url) => {
  // Retrieve current organization and use it to navigate
  cy.url().then((currentUrl) => {
    expect(currentUrl).to.contain('orgs');
    const org = currentUrl.match(/orgs\/(\w*)/)[1];
    const path = url.startsWith('/') ? url : `/${url}`;
    cy.visit(`/orgs/${org}${path}`);
  });
});

Cypress.Commands.add(
  'login',
  (username = Cypress.env('username'), password = Cypress.env('password')) => {
    cy.visit('/signin');
    cy.get('#login').type(username);
    cy.get('#password').type(`${password}{enter}`);
    // The login process is not considered as completed until the UI is rendered
    cy.contains('Logout');
  }
);
