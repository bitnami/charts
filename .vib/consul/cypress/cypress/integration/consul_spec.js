/// <reference types="cypress" />

import { random } from '../support/utils';

const DATACENTER_NAME = Cypress.env('datacenterName');
const REPLICA_COUNT = Cypress.env('replicaCount');
const CONTAINER_PORT = Cypress.env('containerRpcPort');

it('shows all instances of services', () => {
  cy.visit(`/ui/${DATACENTER_NAME}/services`);
  cy.contains('Services');
  cy.get('.linkable').contains('consul');
  cy.get('.detail span').contains(`${REPLICA_COUNT} instances`);
  cy.get('.linkable').click();
  cy.get('[class="address"]').should('have.length', REPLICA_COUNT);
  cy.get('.ember-view').within(() => {
    cy.contains('.header', 'consul').click();
  });
  cy.contains('Agent alive and reachable');
});

it('shows the cluster overview ', () => {
  cy.visit(`/ui/${DATACENTER_NAME}/overview/server-status`);
  cy.get('.consul-server-list').within(() => {
    cy.get('li').should('have.length', REPLICA_COUNT);
  });
  cy.get('.voting-status-leader').click();
  cy.contains('Agent alive and reachable');
});

it('allows the creation of key-value pairs', () => {
  cy.visit(`/ui/${DATACENTER_NAME}/kv`);
  cy.contains('Create').click();
  cy.get('fieldset').within(() => {
    cy.fixture('keys').then((key) => {
      cy.get('input').first().type(`${key.newKey.testKey}.${random}`);
    });
  });
  cy.get('[type="submit"]').click({ force: true });
  cy.get('.notice').contains('Success');
  cy.get('.tabular-collection').within(() => {
    cy.fixture('keys').then((key) => {
      cy.contains(`${key.newKey.testKey}.${random}`);
    });
  });
});

it('shows configured data center', () => {
  cy.visit('/');
  cy.get('[role="banner"]').contains(Cypress.env('datacenterName'));
});

it('is able to display all of the nodes', () => {
  cy.visit(`/ui/${DATACENTER_NAME}/nodes`);
  cy.get('.ember-view').within(() => {
    cy.get('.passing').should('have.length', REPLICA_COUNT);
    cy.get('.passing').first().click();
  });
  cy.contains('Agent alive and reachable');
  cy.contains('Service Instances').click();
  cy.get('.ember-view').within(() => {
    cy.get('.address').contains(CONTAINER_PORT);
  });
  cy.contains('Round Trip Time').click();
  cy.contains('Minimum');
  cy.contains('Maximum');
  cy.contains('Metadata').click();
  cy.get('.ember-view').within(() => {
    cy.contains('consul-network-segment');
  });
});
