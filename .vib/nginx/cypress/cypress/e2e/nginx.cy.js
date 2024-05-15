/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('can access welcome page', () => {
  cy.visit('/');
  cy.contains('Welcome to nginx');
});