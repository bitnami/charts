/*
 * Copyright VMware, Inc.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows to import accounts and list them', () => {
  cy.login();
  // SuiteCRM 8.x uses an iframe that fails with Cypress.
  // That is why we use the legacy url
  cy.visit('/legacy/index.php?module=Accounts&action=index');
  cy.contains('Import').click({ force: true });

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
  cy.get('#finished').click();
  cy.get('.list').within(() => {
    cy.contains(`Test Account ${random}`);
  });
});

it('allows adding a new contact', () => {
  cy.login();
  cy.visit('/#/contacts/index');
  cy.get('.action-button:contains("New")').click({ force: true });
  cy.fixture('contacts').then((contact) => {
    cy.get('.dynamic-field-name-last_name input').type(`${contact.newContact.lastName}.${random}`, { force: true });
    cy.contains('Save').click({ force: true });
    cy.contains('.record-view-name', `${contact.newContact.lastName}.${random}`);
  });
});
