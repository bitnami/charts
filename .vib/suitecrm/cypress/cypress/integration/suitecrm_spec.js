/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows to log in/log out', () => {
  cy.login();
  cy.get('span[class="error"]').should('not.exist');
  cy.contains('SUITECRM DASHBOARD');
  cy.visit('/index.php?module=Users&action=Logout');
  cy.contains('Log In');
});

it('allows to import accounts', () => {
  cy.login();
  cy.visit('/index.php?module=Accounts&action=index');
  cy.contains('Import Accounts').click({ force: true });
  cy.get('input[type="file"]').selectFile('cypress/fixtures/accounts.csv');
  cy.get('input#import_update').click();
  cy.get('#gonext').click();
  cy.contains('Here is how the first several rows');
  cy.get('#gonext').click();
  cy.contains('Check the mappings to make sure that they are what you expect');
  cy.get('#gonext').click();
  cy.contains('perform a duplicate check');
  cy.get('#importnow').click();
  cy.contains('View Import Result');
  cy.contains('View Accounts').click({ force: true });
  cy.get('[title="Edit"]').its('length').should('gt', 1);
});

it('allows adding a new user', () => {
  cy.login();
  cy.visit('index.php?module=Users&action=index');
  cy.contains('Create New User').click({ force: true });
  cy.fixture('users').then((user) => {
    cy.get('#user_name').type(`${user.newUser.username}.${random}`);
    cy.get('#first_name').type(`${user.newUser.firstName}.${random}`);
    cy.get('#last_name').type(`${user.newUser.lastName}.${random}`);
    cy.get('#Users0emailAddress0').type(`${user.newUser.email}.${random}`);
    cy.get('#SAVE_FOOTER').click();
    cy.get('#tab2').click();
    cy.get('#new_password').type(`${user.newUser.password}.${random}`);
    cy.get('#confirm_pwd').type(`${user.newUser.password}.${random}`);
    cy.get('#SAVE_FOOTER').click({ force: true });
    cy.contains('View Users').click({ force: true });
    cy.contains(`${user.newUser.username}.${random}`);
  });
});

it('allows adding a new contact', () => {
  cy.login();
  cy.visit('/index.php?module=Contacts&action=index');
  cy.contains('Create Contact').click({ force: true });
  cy.fixture('contacts').then((contact) => {
    cy.get('#account_name').type(`${contact.newContact.firstName}.${random}`);
    cy.get('#last_name').type(`${contact.newContact.lastName}.${random}`);
    cy.get('#primary_address_street').type(
      `${contact.newContact.address}.${random}`
    );
    cy.get('#SAVE').click();
    cy.contains(
      '.module-title-text',
      `${contact.newContact.lastName}.${random}`
    );
  });
});

it('verifies SMTP configuration', () => {
  cy.login();
  cy.visit('index.php?module=Administration&action=index');
  cy.contains('Email Settings').click();
  cy.get('#mail_smtpserver').should('have.value', Cypress.env('emailServer'));
  cy.get('#mail_smtpport').should('have.value', Cypress.env('smtpPort'));
  cy.get('#mail_smtpuser').should('have.value', Cypress.env('smtpUser'));
});
