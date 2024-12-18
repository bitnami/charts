/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import {
  random,
} from '../support/utils';

it('allows to use the API Explorer', () => {
  cy.login();
  // Go to the secrets page
  cy.get('button[aria-label*="Console"]').click();
  // Create a secret
  cy.fixture('operation').then((op) => {
    cy.get('input').type(`${op.operation.command}{enter}`);
    cy.get('pre').contains(`${op.operation.expectedOutput}`).should('be.visible');
  });
});
