/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

import { random } from '../support/utils';

const DATACENTER_NAME = Cypress.env('datacenterName');
const REPLICA_COUNT = Cypress.env('replicaCount');

it('is able to display all of the nodes', () => {
  cy.visit(`/ui/${DATACENTER_NAME}/nodes`);
  cy.get('div[class*=consul-node-list]').within(() => {
    cy.get('.passing').should('have.length', REPLICA_COUNT);
    cy.get('.leader').click();
  });
  cy.contains('Agent alive and reachable');
  cy.contains('Service Instances').click();
  cy.contains('Metadata').click();
  cy.get('tbody.ember-view').within(() => {
    cy.contains('consul-network-segment');
  });
});

it('allows the creation of key-value pairs', () => {
  cy.visit(`/ui/${DATACENTER_NAME}/kv`);
  cy.contains('Create').click();
  cy.get('fieldset').within(() => {
    cy.fixture('keys').then((key) => {
      cy.get('input').first().type(`${key.newKey.testKey}.${random}`);
    });
  });
  cy.contains('Save').click({ force: true });
  cy.contains('Success');
  cy.get('.tabular-collection').within(() => {
    cy.fixture('keys').then((key) => {
      cy.contains(`${key.newKey.testKey}.${random}`);
    });
  });
});
