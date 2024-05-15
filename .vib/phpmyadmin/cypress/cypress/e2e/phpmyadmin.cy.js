/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows creating a database and a table', () => {
  cy.login();
  cy.visit('/index.php?route=/server/databases');
  cy.fixture('testdata').then((td) => {
    cy.get('#text_create_db').type(`${td.databaseName}.${random}`, {
      force: true,
    });
    cy.contains('input', 'Create').click({ force: true });
    cy.get('[name="table"]').type(`${td.tableName}.${random}`);
    cy.get('[name="num_fields"]').clear().type(td.columnNumber);
    cy.get('[type="submit"]').click();
    cy.get('#field_0_1').type(`${td.columnName}.${random}`);
    cy.get('.btn-primary').click();
    cy.visit('/index.php');
    cy.contains(`${td.databaseName}.${random}`).scrollIntoView().click({force: true});
    cy.contains(`${td.tableName}.${random}`).click({force: true});
    cy.contains('.table-responsive-md', `${td.columnName}.${random}`);
  });
});

