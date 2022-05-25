/// <reference types="cypress" />
import { random, getPageUrlFromTitle, getUserFromEmail } from './utils';

// it('allows to log in/log out', () => {
//   cy.login();
//   cy.contains('You must specify a valid username and password').should(
//     'not.exist'
//   );
//   cy.contains('SUITECRM DASHBOARD');
//   cy.visit('/index.php?module=Users&action=Logout');
//   cy.contains('#bigbutton', 'Log In');
// });

it('allows to import accounts', () => {
  cy.login();

  cy.get('.all').trigger('mouseover').click({ force: true });

  cy.contains('Accounts').click();
  cy.get('#loadingPage').should('not.be.visible');

  cy.get('#modulelinks').click();
  cy.contains('Import Accounts').click();
  cy.get('input[type="file"]').selectFile('cypress/fixtures/accounts.csv');
  cy.get('input#import_update').click();
  cy.get('#gonext').click();
  cy.contains('Here is how the first several rows');
  cy.get('#gonext').click();
  cy.contains('Check the mappings to make sure that they are what you expect');
  cy.get('#gonext').click();
  cy.contains('perform a duplicate check');
  cy.get('#importnow').click();
  cy.contains('records updated successfully');
  cy.get('#modulelinks').click();
  cy.contains('View Accounts').click();
  cy.get('[title="Edit"]').its('length').should('gt', 1);
});

// it('allows adding a new user', () => {
//   cy.login();
//   cy.get('#with-label').click();
//   cy.get('#admin_link').click({ force: true });
//   cy.get('#user_management').click();
//   cy.contains('Create New User').click({ force: true });
//   cy.fixture('users').then((user) => {
//     cy.get('#user_name').type(`${user.newUser.username}.${random}`);
//     cy.get('#first_name').type(`${user.newUser.firstName}.${random}`);
//     cy.get('#last_name').type(`${user.newUser.lastName}.${random}`);
//     cy.get('#Users0emailAddress0').type(`${user.newUser.email}.${random}`);
//     cy.get('#SAVE_FOOTER').click();
//     cy.get('#tab2').click();
//     cy.get('#new_password').type(`${user.newUser.password}.${random}`);
//     cy.get('#confirm_pwd').type(`${user.newUser.password}.${random}`);
//     cy.get('#SAVE_FOOTER').click({ force: true });
//     cy.contains('View Users').click({ force: true });
//     cy.contains(`${user.newUser.username}.${random}`);
//   });
// });
