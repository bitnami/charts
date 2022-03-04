const COMMAND_DELAY = 500;

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
    cy.clearCookies();
    cy.visit('/login')
    cy.get('[name*="user"]').type(username).should('have.value',username);
    cy.get('input#current-password').type(password).should('have.value',password);
    cy.get('[aria-label="Login button"]').click();
});
