/// <reference types="cypress" />
import { random } from './utils';

it('allows the user to log in and log out', () => {
  cy.login();
  cy.contains('[role="alert"]', 'Access denied').should('not.exist'); //checks if login was successful
  cy.get('a[title="Log out"]').click();
  cy.contains('#login_form', 'Log in');
});

it('allows creating a database and a table', () => {
  cy.login();
  cy.visit('index.php?route=/server/databases');
  cy.fixture('testdata').then((td) => {
    cy.get('#text_create_db').type(`${td.databaseName}.${random}`);
    cy.get('#buttonGo').click();
    cy.get('.lock-page [type="text"]').type(`${td.tableName}.${random}`);
    cy.get('.lock-page [type="number"]').clear().type(td.columnNumber);
    cy.contains('[type="submit"]', 'Go').click();
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

it('allows importing a table and executing a query', () => {
  cy.login();
  cy.visit('index.php?route=/database/structure&server=1&db=mysql');
  cy.contains('Import').click();
  cy.get('#input_import_file').selectFile('cypress/fixtures/testdata.sql', {
    force: true,
  });
  cy.get('#buttonGo').click();
  cy.contains('No database selected', '[role="alert"]').should('not.exist');
  cy.contains('Import has been successfully finished');
  cy.fixture('testdata').then((td) => {
    cy.contains('[title="Browse"]', td.importedDatabaseName).click();
  });
  cy.contains('#topmenu', 'SQL');
  cy.visit('/index.php?route=/table/sql&db=mysql&table=authors');
  cy.get('#button_submit_query').scrollIntoView().click();
  cy.contains('Showing rows');
});

it('allows adding a user', () => {
  cy.login();
  cy.visit('index.php?route=/server/privileges&viewing_mode=server');
  cy.get('#add_user_anchor').click();
  cy.fixture('testdata').then((td) => {
    cy.get('#pma_username').type(`${td.username}.${random}`);
    cy.get('#text_pma_pw').type(td.password);
    cy.get('#text_pma_pw2').type(td.password);
    cy.get('#adduser_submit').click();
  });
  cy.contains('You have added a new user.');
});

it('shows the list of installed plugins', () => {
  cy.login();
  cy.visit('index.php?route=/server/plugins');
  cy.fixture('plugins').then((plugin) => {
    cy.get('#plugins-authentication').contains(plugin.installedPlugins.SQL);
    cy.get('#plugins-datatype').contains(plugin.installedPlugins.MariaDB);
  });
});
