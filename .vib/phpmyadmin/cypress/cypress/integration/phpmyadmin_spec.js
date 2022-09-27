/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows creating a database and a table', () => {
  cy.login();
  cy.visit('index.php?route=/server/databases');
  cy.fixture('testdata').then((td) => {
    cy.get('#text_create_db').type(`${td.databaseName}.${random}`, {
      force: true,
    });
    cy.get('#buttonGo').click({ force: true });
    cy.get('.lock-page [type="text"]').type(`${td.tableName}.${random}`);
    cy.get('.lock-page [type="number"]').clear().type(td.columnNumber);
    cy.contains('[type="submit"]', 'Create').click();
    cy.get('#field_0_1').type(`${td.columnName}.${random}`);
    cy.get('.btn-primary').click();
    cy.visit('index.php');
    cy.contains('a', `${td.databaseName}.${random}`).scrollIntoView().click({
      force: true,
    });
    cy.contains(
      '#pma_navigation_tree_content',
      `${td.tableName}.${random}`
    ).click({
      force: true,
    });
    cy.contains('.table-responsive-md', `${td.columnName}.${random}`);
  });
});

