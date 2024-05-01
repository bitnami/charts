/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('allows the execution of a query', () => {
  const QUERY_KEYWORD = 'vector';
  const QUERY_VALUE = '3000';

  cy.visit('/graph');
  cy.contains('.alert', 'No data queried').should('be.visible');
  cy.get('.cm-line').type(`${QUERY_KEYWORD}(${QUERY_VALUE})`, '{enter}');
  cy.get('.execute-btn').click();
  cy.contains('.tab-content', QUERY_VALUE);
});

it('allows listing all installed stores', () => {
  cy.visit('/stores');
  cy.contains('tr', Cypress.env('storePort')).within(() => {
    cy.get('[data-testid="health"]').contains('UP');
  });
  cy.contains('tr', Cypress.env('receivePort')).within(() => {
    cy.get('[data-testid="health"]').contains('UP');
  });
});
