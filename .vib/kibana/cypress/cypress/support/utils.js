/*
 * Copyright VMware, Inc.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

export let random = (Math.random() + 1).toString(36).substring(9);

export const skipTheWelcomeScreen = () => {
  // There is a bug introduced in Chromium 114+ that causes a redirection loop
  // Workaround proposed at https://github.com/cypress-io/cypress/issues/25891
  // TODO: remove workaround once VIB Cypress version is updated to 13.6.3+
  if(top.location.protocol == 'https:') {
    top.history.replaceState('', '', top.location.href.replace('https://', 'http://'))
  }
  cy.visit('/');
  cy.get('[data-test-subj="kbnLoadingMessage"]').should('not.exist');
  cy.get('.euiLoadingSpinner').should('not.exist');
  cy.get('body').then(($body) => {
    if ($body.text().includes('Explore on my own')) {
      cy.get('[data-test-subj="skipWelcomeScreen"]').click();
    }
  });
};
