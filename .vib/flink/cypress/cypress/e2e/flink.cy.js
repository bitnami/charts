/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('should show available task slots', () => {
  cy.visit('/')
  cy.contains('div.field', 'Total Task Slots').within(() => {
    cy.contains('span', /^\d+$/).should(($span) => {
      const num = parseInt($span.text());
      expect(num).to.be.greaterThan(0); // Asserts that the number in the second span is greater than 0
    });
  });
})

it('should show completed jobs', () => {
  cy.visit('/')
  cy.contains('span', 'FINISHED')
})

