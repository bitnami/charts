/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows uploading a dashboard as JSON file', () => {
  cy.login();
  cy.visit('/dashboard/import');
  cy.get('[type=file]').selectFile(
    'cypress/fixtures/test-dashboard.json',
    { force: true }
  );

  cy.fixture('dashboards').then((dashboard) => {
    cy.get('[data-testid*="data-testid-import-dashboard-title"]')
      .clear()
      .type(`${dashboard.newDashboard.title} ${random}`);
    cy.get('[data-testid*="data-testid-import-dashboard-submit"]').click();
    cy.visit('dashboards');
    cy.contains(`${dashboard.newDashboard.title} ${random}`);
  });
});

it('allows creating and deleting a data source', () => {
  cy.login();
  cy.visit('/datasources/new');
  cy.fixture('datasources').then((datasource) => {
    cy.contains('button', datasource.newDatasource.type).click({ force: true });
  });
  cy.get('#basic-settings-name').invoke('attr', 'value').then((datasourceName) => {
    cy.visit('/datasources');
    cy.contains('a', datasourceName).click({ force: true });
    cy.contains('button', 'Delete').click();
    cy.get('[data-testid*="Confirm"]').click();
    cy.get('[data-testid*="data-testid Alert success"]').should('be.visible');
  });
});

it('checks admin settings endpoint', () => {
  cy.request({
    method: 'GET',
    url: '/api/admin/settings',
    form: true,
    auth: {
      username: Cypress.env('username'),
      password: Cypress.env('password'),
    },
  }).then((response) => {
    expect(response.status).to.eq(200);
    expect(response.body).to.include.all.keys(
      'alerting',
      'analytics',
      'security'
    );
  });
});
