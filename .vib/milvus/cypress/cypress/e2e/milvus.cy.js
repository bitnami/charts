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
  cy.wait(50000);
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
    // Add sample data
    cy.reload();
    cy.wait(50000);
    cy.get('button[class*=MuiTab-root]').contains('Data').click({force: true});
    cy.get('span').contains('Insert Sample Data').click({force: true});
    cy.wait(2000);
    cy.get('button[type="submit"]').contains('Import').click({force: true});
    // Check sample data table contains at least 1 entry
    cy.get('button').contains('Query').click({force: true});
    cy.get('td [type="checkbox"]');
  });
});
