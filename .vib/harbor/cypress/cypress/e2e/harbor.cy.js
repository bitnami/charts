/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows creating a project', () => {
  cy.login();
  cy.visit('/harbor/projects');
  cy.fixture('projects').then((project) => {
    cy.contains('New Project').click();
    cy.get('[id*="project_name"]').type(`${project.newProject.name}-${random}`);
    cy.contains('button', 'OK').should('not.be.disabled').click();
    cy.contains('Created project successfully');
  });
});

it('allows creating a registry', () => {
  cy.login();
  cy.visit('/harbor/registries');
  cy.fixture('registries').then((registry) => {
    cy.contains('New Endpoint').click();
    cy.get('#adapter').select(`${registry.newRegistry.provider}`);
    cy.get('#destination_name').type(`${registry.newRegistry.name}-${random}`);
    cy.get('#destination_url').type(`${registry.newRegistry.url}`);
    cy.contains('Test Connection').should('not.be.disabled').click();
    cy.contains('Connection tested successfully');
    cy.contains('button', 'OK').should('not.be.disabled').click();
    cy.contains('.datagrid-table', `${registry.newRegistry.name}-${random}`);
  });
});

it('allows launching a vulnerability scan', () => {
  cy.login();
  cy.visit('/harbor/interrogation-services/scanners');
  cy.contains('.datagrid-row', 'Trivy').within(() => {
    cy.contains('Enabled');
  });
  cy.contains('Vulnerability').click();
  cy.contains('SCAN NOW').click();
  cy.contains('Trigger scan all successfully');
});

it('checks every subcomponent status', () => {
  cy.request({
    method: 'GET',
    url: '/api/v2.0/health',
    form: true,
    auth: {
      username: Cypress.env('username'),
      password: Cypress.env('password'),
    },
  }).then((response) => {
    expect(response.status).to.eq(200);
    expect(response.body.status).to.eq('healthy');
  });
});
