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
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> bitnami-master
    cy.get('[name="user"]').type(username).should('have.value',username);
    cy.get('input#current-password').type(password).should('have.value',password);
    cy.get('[aria-label="Login button"]').click();
    cy.get('div').contains('Invalid username').should('not.exist');
<<<<<<< HEAD
=======
    cy.get('input[aria-label="Username input field"]').should('be.visible').type(username);
    cy.get('input#current-password').should('be.visible').type(password);
    cy.get('[aria-label*="Login button"]').click();
>>>>>>> bitnami-master
=======
>>>>>>> bitnami-master
});
