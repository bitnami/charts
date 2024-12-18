/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

// This is a read-only UI, so we simply check the tag created in the init job
it('should find created tag', () => {
  cy.visit('/')
  cy.contains('a', 'main').click();
  cy.fixture('tags').then((tag) => {
    cy.contains(tag.name);
  });
})
