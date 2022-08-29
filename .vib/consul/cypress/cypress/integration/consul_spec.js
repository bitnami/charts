/// <reference types="cypress" />

import { random } from '../support/utils';

const DATACENTER_NAME = Cypress.env('datacenterName');
const REPLICA_COUNT = Cypress.env('replicaCount');
const CONTAINER_PORT = Cypress.env('containerRpcPort');

it('is able to display all of the nodes', () => {
  cy.visit(`/ui/${DATACENTER_NAME}/nodes`);
  cy.get('.ember-view').within(() => {
    cy.get('.passing').should('have.length', REPLICA_COUNT);
    cy.get('.leader').click();
  });
  cy.contains('Agent alive and reachable');
  cy.contains('Service Instances').click();
  cy.get('.ember-view').within(() => {
    cy.get('.address').contains(CONTAINER_PORT);
  });
  cy.contains('Metadata').click();
  cy.get('.ember-view').within(() => {
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
  cy.get('.notice').contains('Success');
  cy.get('.tabular-collection').within(() => {
    cy.fixture('keys').then((key) => {
      cy.contains(`${key.newKey.testKey}.${random}`);
    });
  });
});
