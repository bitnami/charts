/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('allows to access auth-protected resource', () => {
  // DEX is deployed at localhost:5556, which is not exposed. In order to prevent failed redirections
  // to this port, direct interaction (e.g. clicking) is generally avoided.

  // OAuth2
  cy.safeRedirectVisit(`/oauth2/start?rd=${Cypress.env('upstreamURL')}`);

  // DEX UI
  cy.contains('a', 'Log in with Example').invoke('attr', 'href').then((url) => {
    cy.safeRedirectVisit(url);
  })
  cy.contains('button', 'Grant Access').click();

  // Back to OAuth2: Auth-protected resource
  cy.contains(Cypress.env('upstreamContent'));
});
