/// <reference types="cypress" />
describe('Automatic update configuration test', () => {

    beforeEach(() => {
      cy.login();
    })

    it('checks the value of auto update status', () => {
      cy.visit("wp-admin/update-core.php");
      cy.get('.auto-update-status').should('contain.text', 'This site is automatically kept up to date with maintenance and security releases of WordPress only.');
    })
})
