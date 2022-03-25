const COMMAND_DELAY = 1000;

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

Cypress.Commands.add("login", (
    username = Cypress.env("username"),
    password = Cypress.env("password")
) => {
    cy.visit('');
    cy.get('#input_username').should('be.visible').type(username);
    cy.get('#input_password').should('be.visible').type(password);
    cy.get('#input_go').click();
    cy.contains('#pma_errors','Access denied').should('not.exist');
});
