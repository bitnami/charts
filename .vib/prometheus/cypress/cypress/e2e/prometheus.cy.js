/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('allows executing a query and displaying response data for each deployment', () => {
  const deployments = Cypress.env('deployments');
  // Wait 2 times the scrape interval
  cy.wait(2 * Cypress.env('scrapeInterval'));
  cy.visit(`/graph`);
  Object.keys(deployments).forEach((podName, i) => {
    const query = Object.values(deployments)[i].query;
    cy.get('[role="textbox"]');
    cy.visit(`/graph?g0.expr=${query}`);
    cy.contains('span', `"${podName}"`)
  })
});

it('checks targets status', () => {
  const targets = Cypress.env('targets');

  Object.keys(targets).forEach((podName, i) => {
    const podData = Object.values(targets)[i];
    cy.visit(`/targets?search=${podName}`);
    cy.get('a[href$=metrics]').should('have.length', `${podData.replicaCount}`);
  })
});
