/// <reference types="cypress" />
import { random } from './utils';

it('allows login and logout', () => {
  cy.visit('/');
  cy.contains(Cypress.env('dokuwikiFullName'));
  cy.login();
  cy.get('.error').should('not.exist');
  cy.contains('Log Out');
});

it('allows the user to update profile', () => {
  cy.login();
  cy.visit('/start?do=profile');
  cy.fixture('admins').then((admin) => {
    cy.get('input[name="email"]')
      .clear()
      .type(`${admin.newAdmin.email}.${random}`);
  });
  cy.get('input[name="oldpass"]').first().type(Cypress.env('password'));
  cy.contains('Save').click();
  cy.contains('User profile successfully updated.');
});

it('allows the user to validate and modify configuration settings', () => {
  cy.login();
  cy.visit('start?do=admin&page=config');
  cy.get('#config___title').should(
    'contain.value',
    Cypress.env('dokuwikiFullName')
  );
  cy.fixture('settings').then((setting) => {
    cy.get('#config___savedir').should(
      'contain.value',
      setting.newSetting.saveFolder
    );
    cy.get('#config___dmode').should(
      'contain.value',
      setting.newSetting.directoryCreationMode
    );
  });

  cy.get('#config___allowdebug').click();
  cy.contains('button[accesskey="s"]', 'Save').click();
  cy.contains('Settings updated successfully.');
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

THIS TEST WILL NOT WORK FOR NOW
it('allows image upload', () => {
  cy.login();
  cy.contains('a', 'Media Manager').click({ force: true }); //The element type is important to identify the element
  cy.contains('Upload').click();
  cy.contains('Select files').click();
  cy.get('input[type="file"]').selectFile('cypress/fixtures/sample.pdf', {
    force: true,
  });
  cy.contains('button[type="submit"]', 'Upload').click();
});

it('allows file upload', () => {
  cy.login();
  cy.visit('start?do=admin');
  cy.contains('User Manager').click();
  cy.get('input[type="file"]').selectFile('cypress/fixtures/wikiusers.csv', {
    force: true,
  });
  //cy.contains('button[type="submit"]', 'Upload').click();
  cy.contains('button', 'Import New Users').click();
});
