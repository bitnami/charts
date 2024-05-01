/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('allows running a query', () => {
  cy.visit('/play');
  cy.get('#user')
    .clear()
    .type(Cypress.env('username'), { force: true });
  cy.get('#password').type(Cypress.env('password'));
  cy.fixture('queries').then((queries) => {
    cy.get('#query').type(queries.dbQuery.query);
    cy.get('#run').click();
    cy.contains(queries.dbQuery.output.header);
    cy.contains(queries.dbQuery.output.return);
  });
});
