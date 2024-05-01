/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

export let random = (Math.random() + 1).toString(36).substring(9);

export const skipTheWelcomeScreen = () => {
  cy.visit('/');
  cy.get('[data-test-subj="kbnLoadingMessage"]').should('not.exist');
  cy.get('.euiLoadingSpinner').should('not.exist');
  cy.get('body').then(($body) => {
    if ($body.text().includes('Explore on my own')) {
      cy.get('[data-test-subj="skipWelcomeScreen"]').click();
    }
  });
};
