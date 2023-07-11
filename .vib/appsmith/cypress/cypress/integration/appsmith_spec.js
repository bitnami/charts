/*
 * Copyright VMware, Inc.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import {
  random,
} from '../support/utils';

it('allows to create a new project', () => {
  cy.login();
  // Go to the templates page
  cy.get('[class*="templates-tab"]').click();
  cy.contains('[data-testid="template-card"]', 'Marketing Portal').within(() => {
    cy.get('[class*="fork-button"]').click();
  })
  // Create an application from the Marketing Portal template
  cy.contains('Fork template').click();
  cy.contains('Deploy');
  // Check if the application exists in the applications page
  cy.visit('/applications');
  cy.contains('Customer Communications portal');
});

it('allows to change workspace settings', () => {
  cy.login();
  cy.get('.t--options-icon').click();
  cy.contains('Settings').click();

  cy.fixture('user-settings').then(($us) => {
    cy.get('input[placeholder="Workspace name"]')
      .clear()
      .type(`${$us.instanceName}-${random}`, { force: true });
    cy.get('h2').contains(`${$us.instanceName}-${random}`);
  });
});
