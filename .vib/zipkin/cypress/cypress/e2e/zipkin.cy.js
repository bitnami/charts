/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

// We check the pushed trace in the Job
it('should find pushed trace', () => {
  cy.visit('/')
  cy.contains('a', 'Dependencies').click();
  cy.fixture('services').then((service) => {
    cy.contains('div[class*="root"]', 'Start Time').get('input').eq(2).clear().type(service.checkTime);
    cy.contains('button', 'Run Query').click();
    cy.get('[role="combobox"]').click();
    cy.contains(service.name);
  });
})
