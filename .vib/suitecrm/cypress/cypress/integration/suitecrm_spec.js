/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows to import accounts and list them', () => {
  cy.login();
  cy.visit('/index.php?module=Accounts&action=index');
  cy.contains('Import Accounts').click({ force: true });

  const accountsFile = 'cypress/fixtures/accounts.csv';
  cy.readFile(accountsFile).then((data) => {
    const randomizedData = data.replace(/Test Account [a-z0-9_]+,/g, `Test Account ${random},`);
    cy.writeFile(accountsFile, randomizedData);
  });
  cy.get('[type="file"]').selectFile(accountsFile);
  cy.get('#import_update').click();
  for (let i = 2; i < 5; i++) {
    cy.get('#gonext').click();
    cy.contains(`Step ${i}`);
  }
  cy.get('#importnow').click();
  cy.contains('Exit').click({ force: true });
  cy.get('.list').within(() => {
    cy.contains(`Test Account ${random}`);
  });
});

it('allows adding a new contact', () => {
  cy.login();
  cy.visit('/index.php?module=Contacts&action=index');
  cy.contains('Create Contact').click({ force: true });
  cy.fixture('contacts').then((contact) => {
    cy.get('#last_name').type(`${contact.newContact.lastName}.${random}`);
    cy.contains('Save').click();
    cy.contains('h2', `${contact.newContact.lastName}.${random}`);
  });
});
