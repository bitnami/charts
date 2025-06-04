/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('lists all components in a healthy state', () => {
  cy.visit('/');
  // Wait for DOM content to load
  cy.wait(10000);

  cy.get('span[class*="HealthLabel"]').each(($span) => {
    cy.wrap($span).should('have.text', 'healthy');
  });

  const members = ['endpointslices', 'pods', 'services', 'ingresses', 'endpoints', 'nodes']
  members.forEach((e) => {
    cy.get('span[class*="ComponentList"]').contains(`discovery.kubernetes.${e}`).should('be.visible')
  })

  // Check graph view
  cy.get('a[href="/graph"]').click();

  members.forEach((e) => {
    cy.get(`div[data-nodeid*="discovery.kubernetes.${e}"]`).should('exist').and('be.visible');
  });
});

it('clustering in a healthy state', () => {
  cy.visit('/clustering');

  cy.get('span:not([class*="idName"])').each(($span) => {
    cy.wrap($span).should('include.text', '✅');
  });
});