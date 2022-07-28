/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows login and logout', () => {
  cy.login();
  cy.get('.error').should('not.exist');
  cy.contains('Log Out').click();
  cy.get('#login');
});

it('allows adding users', () => {
  cy.login();
  cy.visit('login?do=admin&page=usermanager');
  cy.fixture('users').then((user) => {
    cy.get('#add_userid').type(`${user.newUser.userName}.${random}`);
    cy.get('#add_userpass').type(`${user.newUser.password}.${random}`);
    cy.get('#add_userpass2').type(`${user.newUser.password}.${random}`);
    cy.get('#add_username').type(`${user.newUser.realName}.${random}`);
    cy.get('#add_usermail').type(`${user.newUser.email}.${random}`);
  });
  cy.contains('button', 'Add').click();
  cy.contains('User added successfully');
});

it('allows editing a page in the playground', () => {
  cy.login();
  cy.visit('/playground:playground');
  cy.get('.edit > a').click({ force: true });
  cy.fixture('pages').then((page) => {
    cy.get('#wiki__text').clear().type(`${page.newPage.content}.${random}`);
    cy.contains('button', 'Save').click();
    cy.contains('.page', `${page.newPage.content}.${random}`);
  });
});
