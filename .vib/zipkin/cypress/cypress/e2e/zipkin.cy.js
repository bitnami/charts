/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

// We check the pushed trace in the Job
it('should find pushed trace', () => {
  cy.visit('/')
  cy.get('[data-testid="add-button"]').click();
  cy.contains('li', 'serviceName').click();
  cy.fixture('services').then((service) => {
    cy.contains(service.name);
  });
})
