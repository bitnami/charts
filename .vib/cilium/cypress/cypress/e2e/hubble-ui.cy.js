/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('shows the welcome page', () => {
  cy.visit('/');
  cy.contains('Welcome');
});

// TO DO: add tests that browse the UI looking for
// the namespaces observability information
