/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('allows executing a query and displaying response data for each deployment', () => {
  const deployments = Cypress.env('deployments');

  cy.visit(`/graph`);
  Object.keys(deployments).forEach((podName, i) => {
    const query = Object.values(deployments)[i].query;

    cy.get('[role="textbox"]').clear({force: true}).type(`${query}{enter}`);
    cy.contains('Execute').click();
    cy.contains('.data-table', `container="${podName}"`)
  })
});

it('allows executing a query and displaying response data for each service monitor', () => {
  const monitors = Cypress.env('monitors');

  cy.visit(`/graph`);
  Object.keys(monitors).forEach((jobName, i) => {
    const query = Object.values(monitors)[i].query;

    cy.get('[role="textbox"]').clear({force: true}).type(`${query}{enter}`);
    cy.contains('Execute').click();
    cy.contains('.data-table', `job="${jobName}"`)
  })
});

it('checks targets status', () => {
  const targets = Cypress.env('targets');

  Object.keys(targets).forEach((podName, i) => {
    const podData = Object.values(targets)[i];

    cy.visit(`/targets?search=${podName}`);
    cy.contains(`${podData.replicaCount}/${podData.replicaCount} up`);
  })
});
