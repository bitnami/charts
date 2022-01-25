/// <reference types="cypress" />
describe('Login page', () => {

  beforeEach(() => {
    cy.clearCookies();
    cy.visit('/wp-login.php')
    cy.wait(500)
  })

  it('allows login to a valid user.', () => {
    cy.get('#user_login').type(Cypress.env('username')).should('have.value', Cypress.env('username'));
    cy.get('#user_pass').type(Cypress.env('password')).should('have.value', Cypress.env('password'));
    cy.get('#wp-submit').click();
    cy.get('#login_error').should('not.exist')
  })

  it('disallows login to an invalid user.', () => {
    cy.fixture('user').then((user) => {
      cy.get('#user_login').type(user.username).should('have.value', user.username);
      cy.get('#user_pass').type(user.password).should('have.value', user.password);
    })
    cy.get('#wp-submit').click();
    cy.fixture('user').then((user) => {
      cy.get('#login_error').should('contain.text', `The username ${user.username} is not registered on this site.`);
    })
  })

  it('disallows login to a valid user with wrong password.', () => {
    cy.get('#user_login').type(Cypress.env('username')).should('have.value', Cypress.env('username'));
    cy.fixture('user').then((user) => {
      cy.get('#user_pass').type(user.password).should('have.value', user.password);
    })
    cy.get('#wp-submit').click();
    cy.get('#login_error').should('contain.text', 'Error: The password you entered for the username user is incorrect. Lost your password?');
  })
})
