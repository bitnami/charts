/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('can access backend server', () => {
  // HAProxy is configured with an NGINX server deployed as a sidecar, which
  // plays the role of backend. Successful access to NGINX means HAProxy is
  // correctly routing!
  cy.visit('/');
  cy.contains('Welcome to nginx')
});