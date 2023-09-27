/*
 * Copyright VMware, Inc.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import {
  random,
} from '../support/utils';

it('allows to create a collection', () => {
  cy.login();
  // Go to the collections page
  cy.visit('#/collections');
  cy.get('button').contains('Collection').click({force: true});
  // Create a collection
  cy.fixture('collection').then((c) => {
    cy.get('[data-cy="collection_name"]').type(`${c.collection.name}${random}`);
    cy.get('[data-cy="collection_name"]').type(`${c.collection.name}${random}`);
    cy.get('div[class*="MuiTextField"]').contains('div', 'Primary Key').within(() => {
      cy.get('input').type(`${c.collection.idName}${random}`)
    });
    cy.get('div[class*="MuiTextField"]').contains('div','Vector Field').within(() => {
      cy.get('input').type(`${c.collection.vectorName}${random}{enter}`);
    });
    cy.visit('/');
    cy.contains('Overview');
    cy.visit('#/collections');
    cy.get(`[href$="${c.collection.name}${random}"]`).click();
    cy.get('td [role="button"]').contains('Index').click({force: true});
    cy.get('[type="number"]').type(`${c.collection.nlist}{enter}`);
    // Return to the collections page
    cy.visit('/');
    cy.contains('Overview');
    cy.visit('#/collections');
    cy.get(`[href$="${c.collection.name}${random}"]`).trigger('mouseover');
    // Load sample data (we use first as the newest element is the first of the list)
    cy.get('[aria-label="load"]').first().click();
    cy.get('button').contains('Load').click({force: true});
    cy.get(`[href$="${c.collection.name}${random}"]`).trigger('mouseover');
    cy.get('[aria-label*="Import"]').first().click({force: true});
    cy.get('button').contains('Import').click({force: true});
    cy.contains('loaded');
  });
});
