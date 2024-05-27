/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('(ring) is aware of all the replicas', () => {
  cy.visit('/compactor/ring');
  cy.get('tr')
    .filter(':contains("grafana-tempo-compactor-")')
    .then((rows) => {
      expect(rows).to.have.length(Cypress.env('compactorReplicaCount'));
      cy.wrap(rows).each((row) => {
        expect(row).to.contain('ACTIVE');
      });
    });
});

it('lists all components in a healthy state', () => {
  const members = ['compactor', 'distributor', 'ingester', 'querier', 'metrics']
  var numMembers = 0
  members.forEach((e) => {
    numMembers += parseInt(Cypress.env(`${e}ReplicaCount`), 10)
  })

  cy.visit('/memberlist');

  // The lower, the better. Zero --> Healthy
  cy.contains('Health Score: 0');
  cy.contains(`Members: ${numMembers}`);

  // Check a random member's gossipRing port
  var randomMember = members[Math.floor(Math.random()*members.length)];
  cy.contains('tr', `grafana-tempo-${randomMember}-`).then((tr) => {
    expect(tr).to.contain(`:${Cypress.env('gossipRingPort')}`);
  });
});
