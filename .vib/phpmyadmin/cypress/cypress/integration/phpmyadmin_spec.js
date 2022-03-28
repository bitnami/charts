/// <reference types="cypress" />
import {
    random
} from './utils'

it('allows the user to log out', () => {
    cy.login();
    cy.contains('[role="alert"]', 'Access denied').should('not.exist');
    cy.get('a[title="Log out"]').should('be.visible').click();
    cy.get('#login_form').should('be.visible');
})

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
            force: true
        });
        cy.contains('#pma_navigation_tree_content', `${td.tableName}.${random}`).should('be.visible').click({
            force: true
        })
        cy.contains('.table-responsive-md', `${td.columnName}.${random}`).should('be.visible');
    });
})

it('allows importing a table and executing a query', () => {
    cy.login();
    cy.visit('index.php?route=/database/structure&server=1&db=mysql')
    cy.contains('Import').click();
    cy.get('#input_import_file').should('be.visible').selectFile('cypress/fixtures/testdata.sql', {
        force: true
    });
    cy.get('#buttonGo').click();
    cy.contains('No database selected', '[role="alert"]').should('not.exist');
    cy.contains('Import has been successfully finished');
    cy.fixture('testdata').then((td) => {
        cy.contains('[title="Browse"]', 'authors').should('be.visible').click();
        cy.get('#topmenu').should('be.visible').contains('SQL');
        cy.get('[title="SQL"]').should('be.visible').click();
        cy.get('#button_submit_query').should('be.visible').click();
        cy.get('.result_query').should('be.visible').contains('Showing rows');
    })
})

it('allows adding a user', () => {
    cy.login();
    cy.visit('index.php?route=/server/privileges&viewing_mode=server');
    cy.get('#add_user_anchor').click();
    cy.fixture('testdata').then((td) => {
        cy.get('#pma_username').type(`${td.username}.${random}`);
        cy.get('#text_pma_pw').type(td.password);
        cy.get('#adduser_submit').type(td.password);
        cy.get('#adduser_submit').scrollIntoView().click();
    })
    cy.get('.result_query').should('be.visible').contains('You have added a new user.');
})

it('shows the list of installed plugins', () => {
    cy.login();
    cy.visit('index.php?route=/server/plugins');
    cy.get('#plugins-authentication').contains('Native MySQL authentication');
    cy.get('#plugins-datatype').contains('MariaDB');
})
