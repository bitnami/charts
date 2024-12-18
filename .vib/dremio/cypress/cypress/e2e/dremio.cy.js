/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import {
  random,
} from '../support/utils';

it('Allows to import a PostgreSQL database and perform a query', () => {
  cy.login();
  // Go to the collections page
  cy.contains('Add Source').click();
  cy.contains('PostgreSQL').click();
  cy.fixture('database').then((d) => {
    cy.get('#name').should('be.enabled').clear({force: true}).type(`${d.database.name}${random}`);
    // Cannot use # because of the middle dot
    cy.get('[id="config.hostname"]').should('be.enabled').clear({force: true}).type(Cypress.env('postgresql_host'));
    cy.get('[id="config.databaseName"]').should('be.enabled').clear({force: true}).type(Cypress.env('postgresql_db'));
    cy.get('[id="config.username"]').should('be.enabled').clear({force: true}).type(Cypress.env('postgresql_user'));
    cy.get('[id="config.password"]').should('be.enabled').clear({force: true}).type(Cypress.env('postgresql_password'));
    cy.contains('Save').click();
    cy.get(`[href*="source/${d.database.name}${random}"]`);
    // Does not have text as it is an icon, so we need to use the href selector
    cy.get('[href*="new_query"]').click();
    // Ensure the editor is fully loaded
    cy.contains(`${d.database.name}${random}`).click();
    cy.contains('public').click();
    cy.contains(d.database.expectedRes);
  });
});
