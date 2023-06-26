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

  // Create an application from the Marketing Portal template
  cy.contains('[data-cy="template-card"]', 'Marketing Portal').within(() => {
    cy.get('[class*="fork-button"]').click();
  })
  cy.contains('FORK TEMPLATE').click();
  cy.contains('Deploy');
  // Check if the application exists in the applications page
  cy.visit('/applications');
  cy.contains('Customer Communications portal');
});

it('allows to change workspace settings', () => {
  cy.login();
  cy.get('span[class*="workspace-name"]').click();
  cy.get('[data-cy*="workspace-setting"]').click();
  cy.fixture('user-settings').then(($us) => {
    cy.get('input[placeholder="Workspace Name"]')
      .clear()
      .type(`${$us.instanceName}-${random}`, { force: true });
    cy.get('h2').contains(`${$us.instanceName}-${random}`);
  });
});
