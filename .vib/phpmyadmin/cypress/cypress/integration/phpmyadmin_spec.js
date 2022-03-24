/// <reference types="cypress" />
import {
    random
} from './utils'

it('allows the user to log out', () => {
    cy.login();
    cy.get('a[title="Log out"]').click({force:true})
    cy.get('#login_form').should('be.visible');
})

it('allows creating a database and a table', () => {
    cy.login();
    cy.get('#pma_navigation_tree_content').contains('a', 'New').click({
        force: true
    });
    cy.fixture('testdata').then((td) => {
        cy.get('#text_create_db').type(`${td.databaseName}.${random}`);
        cy.get('#buttonGo').click();
        cy.get('.lock-page [type="text"]').type(`${td.tableName}.${random}`);
        cy.get('.lock-page [type="number"]').clear().type(td.columnNumber);
        cy.contains('[type="submit"]', 'Go').click();
        cy.get('#field_0_1').type(`${td.columnName}.${random}`);
        cy.get('.btn-primary').click();
        cy.visit('index.php');
        cy.get('#pma_navigation_tree_content').contains(`${td.databaseName}.${random}`).click({
            force: true
        });
        cy.get('#pma_navigation_tree_content').contains(`${td.tableName}.${random}`).click({
            force: true
        });
        cy.get('.table-responsive-md').contains(`${td.columnName}.${random}`);
    });
})

it('allows importing a table and executing a query', () => {
    cy.login();
    cy.get('#pma_navigation_tree_content').contains('mysql').click();
    cy.contains('Import').click();
    cy.get('#input_import_file').selectFile('cypress/fixtures/testdata.sql', {
        force: true
    });
    cy.get('#buttonGo').click();
    cy.contains('Import has been successfully finished');
    cy.fixture('testdata').then((td) => {
        cy.get('#pma_navigation_tree_content').contains('mysql').click({
            force: true
        });
        cy.get('#pma_navigation_tree_content').contains('authors').click({
            force: true
        });
        cy.get('#topmenu').contains('SQL').click();
        cy.get('#button_submit_query').click();
        cy.get('.result_query').contains('Showing rows');
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
    cy.get('.result_query').contains('You have added a new user.');
})

it('shows the list of installed plugins', () => {
    cy.login();
    cy.visit('index.php?route=/server/plugins');
    cy.get('#plugins-authentication').contains('Native MySQL authentication');
    cy.get('#plugins-datatype').contains('MariaDB');
})
