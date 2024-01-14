/*
 * Copyright VMware, Inc.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows managing a helm chart release', () => {
  cy.login();

  // Prefer UI interaction over direct navigation because the URL includes references to
  // the ns name, which is only known at runtime.
  cy.contains('Catalog').click();

  cy.fixture('releases').then((releases) => {
    const releaseName = `${releases.newRelease.name}-${random}`

    cy.get('#search').type(releases.newRelease.application);
    cy.contains('div.card', releases.newRelease.application).click();
    cy.contains(Cypress.env('registryName'));
    cy.contains('Deploy').click();

    cy.get('#releaseName').type(releaseName);

    // Disable securityContext parameters, as some platforms may not allow to enforce
    // a specific UID/GID when installing
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
