/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows creating a new user', () => {
  cy.login();
  cy.get('[href*="/users"]').click();
  cy.get('#createUser').click();
  cy.fixture('users').then((user) => {
    cy.get('#username').type(`${user.newUser.username}.${random}`);
    cy.get('#email').type(`${user.newUser.email}.${random}`);
    cy.get('#firstName').type(`${user.newUser.firstName}.${random}`);
    cy.get('#lastName').type(`${user.newUser.lastName}.${random}`);
  });
  cy.contains('button', 'Save').click();
  cy.contains('.alert', 'Success');
});

it('allows the upload and delete of a locale ', () => {
  cy.login();
  cy.contains('Localization').click();
  cy.contains('Upload localization').click();
  cy.get('input#import-file').selectFile(
    'cypress/fixtures/empty-localization-file.json',
    {
      force: true,
    }
  );
  cy.fixture('locales').then((locale) => {
    cy.get('#locale').type(`${locale.German}.${random}`);
  });
  cy.contains('button', 'Import').click();
  cy.contains('.alert', 'Success');
});
