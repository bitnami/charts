/// <reference types="cypress" />
describe('SMTP config test', () => {

    beforeEach(() => {
      cy.login();
      cy.visit('wp-admin/admin.php?page=wp-mail-smtp');
    })

    it('checks for presence of WP Mail SMTP', () => {
      cy.get('div').contains('WP Mail SMTP').should('be.visible');
    })

    it('checks for configuration of WP Mail test', () => {
     cy.visit('wp-admin/admin.php?page=wp-mail-smtp-tools&tab=test');
     cy.get('#wp-mail-smtp-setting-test_email').should('have.value', Cypress.env('wordpressEmail'))
    })

    it('checks for configuration of mail server', () => {
      cy.get('#wp-mail-smtp-setting-smtp-host').should('have.value', Cypress.env('smtpMailServer'));
    })

    it('checks for configuration of SMTP port', () => {
      cy.get('#wp-mail-smtp-setting-smtp-port').should('have.value', Cypress.env('smtpPort'))
    })

    it('checks for configuration of SMTP username', () => {
      cy.get('#wp-mail-smtp-setting-smtp-user').should('have.value', Cypress.env('smtpUser'))
    })

    it('checks for configuration of the names emails are sent from', () => {
      cy.get('#wp-mail-smtp-setting-from_name').should('have.value', `${Cypress.env('wordpressFirstName')} ${Cypress.env('wordpressLastName')}`);
    })

})
