/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import {
  random,
} from '../support/utils';

it('allows to create a new app from template', () => {
  cy.login();
  cy.fixture('app').then((app) => {
    // Create new app
    cy.contains('Create new').click();
    cy.get('div[data-testid="t--workspace-action-create-app"]').click();
    // Rename application
    cy.get('.t--application-name').click();
    cy.contains('Rename').click();
    cy.get('.t--application-name').type(`${app.appName}-${random}{enter}`);
    // Go to the templates page
    cy.contains('Start from a template').click();
    // Create an application from the Product Catalog CRUD template
    cy.contains('[data-testid="template-card"]', 'Product Catalog CRUD').click()
    cy.contains('Add selected page');
    // Check if the application exists in the applications page
    cy.visit('/applications');
    cy.contains(`${app.appName}-${random}`);
  });
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
