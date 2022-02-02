/// <reference types="cypress" />
describe('Admin page', () => {

    beforeEach(() => {
      cy.login();
      cy.visit('wp-admin/options-general.php')
    })

    it('checks the blog name', () => {
      cy.get('#blogname').should('have.value', Cypress.env('wordpressBlogname'));
    })

    it('checks the user email', () => {
        cy.get('#new_admin_email').should('have.value', Cypress.env('wordpressEmail'));
    })

})
