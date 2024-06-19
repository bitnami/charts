/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import {
  random,
} from '../support/utils';

it('allows to create a collection', () => {
  cy.login();
  // Go to the collections page
  cy.visit('#/databases');
  // Wait for DOM content to load
  cy.wait(2000);
  cy.get('button').contains('Collection').click({force: true});
  cy.wait(2000);
  cy.fixture('collection').then((c) => {
    // Create collection
    cy.get('[data-cy="collection_name"]').type(`${c.collection.name}${random}`);
    cy.get('div[class*="MuiTextField"]').contains('div', 'Primary Key').within(() => {
      cy.get('input').type(`${c.collection.idName}${random}`)
    });
    cy.get('div[class*="MuiTextField"]').contains('div','Vector Field').within(() => {
      cy.get('input').type(`${c.collection.vectorName}${random}{enter}`);
    });
    // Create collection index and load
    cy.get(`[href$="${c.collection.name}${random}/overview"]`).click({force: true});
    cy.get('span').contains('Create Index').click({force: true});
    cy.get('[placeholder="Index name"]').type(`${c.collection.idName}{enter}`);
    // Reload and wait for DOM content load
    cy.visit('#/databases');
    cy.wait(2000);
    cy.get('td [role="button"]').contains('unloaded').click({force: true});
    cy.get('button').contains('Load').click({force: true});
    cy.contains('loaded');
    // Add sample data
    cy.get(`[href$="${c.collection.name}${random}/overview"]`).click({force: true});
    cy.get('span[class=MuiTab-wrapper]').contains('Data').click({force: true});
    cy.get('span').contains('Insert Sample Data').click({force: true});
    cy.get('button[type="submit"]').contains('Import').click({force: true});
    // Check sample data table contains at least 1 entry
    cy.get('span').contains('Query').click({force: true});
    cy.get('td [type="checkbox"]');
  });
});
