/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows managing a helm chart release', () => {
  cy.login();

  // Prefer UI interaction over direct navigation because the URL includes references to
  // the ns name, which is only known at runtime.
  cy.contains('Catalog').click();
  cy.wait(5000);
  cy.fixture('releases').then((releases) => {
    const releaseName = `${releases.newRelease.name}-${random}`

    cy.contains('div.card', releases.newRelease.application).click();
    cy.contains(Cypress.env('registryName'));
    cy.contains('Deploy').click();
    cy.wait(5000);
    cy.get('#releaseName').type(releaseName);

    // TKG clusters may enforce PodSecurity policies, so podSecurityContext and
    // containerSecurityContext need to be enabled. On the other hand, OpenShift
    // does not allow to enforce a specific UID/GID when deploying, so they should
    // be disabled. This hack tries to identify when the chart is deployed in a
    // TKG-based cluster (running on AWS) and skips disabling these params.
    //
    // Other clusters currently do not enforce any policy, so having them enabled or
    // disabled should not make any difference.
    if (!Cypress.config('baseUrl').includes('amazonaws')) {
        cy.get('input[title="Search"]').type('SecurityContext{enter}');

        // 1. containerSecurity Context
        cy.contains('td', 'containerSecurityContext').within(() => {
          cy.get('cds-button').click();
        });
        cy.contains('tr', 'containerSecurityContext/enabled').within(() => {
          cy.contains('cds-toggle', 'true').click('left');
        });
        cy.contains('td', 'containerSecurityContext').within(() => {
          cy.get('cds-button').click();
        });

        // 2. podSecurityContext Context
        cy.contains('td', 'podSecurityContext').within(() => {
          cy.get('cds-button').click();
        });
        cy.contains('tr', 'podSecurityContext/enabled').within(() => {
          cy.contains('cds-toggle', 'true').click('left');
        });
        cy.contains('td', 'containerSecurityContext').within(() => {
          cy.get('cds-button').click();
        });
    }
    cy.contains('cds-button', 'Deploy').click();
    cy.get('.application-status-pie-chart-title', { timeout: (Cypress.config('defaultCommandTimeout') * 3) }).should(
      'have.text',
      'Ready'
    );

    cy.contains('Delete').click();
    cy.get('cds-modal-actions').within(() => {
      cy.contains('Delete').click();
    });
    cy.contains(releaseName).should('not.exist');
  });
});
