/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

import { skipTheWelcomeScreen, random } from '../support/utils';

before(() => {
  skipTheWelcomeScreen();
});

it('allows uploading data', () => {
  // Wait for DOM content to load
  cy.wait(2000);
  cy.get('body').then(($body) => {
    // Close welcome tutorial pop-up if present
    if ($body.find('[data-test-subj="skipWelcomeScreen"]').is(':visible')) {
      cy.get('[data-test-subj="skipWelcomeScreen"]').click();
    }
  });
  cy.get('[data-test-subj="uploadFile"]').click();
  cy.get('[type=file]').selectFile(
    'cypress/fixtures/test-data-to-import.ndjson',
    {
      force: true,
    }
  );
  cy.get('[data-test-subj="dataVisualizerFileOpenImportPageButton"]').click();
  cy.fixture('indexes').then((index) => {
    cy.get('[data-test-subj="dataVisualizerFileIndexNameInput"]').type(
      `${index.newIndex.name}.${random}`
    );
  });
  cy.get('[data-test-subj="dataVisualizerFileImportButton"]').click();
  cy.get('[data-test-subj="dataVisualizerFileImportSuccessCallout"]');
});

it('allows creating a dashboard and visualization', () => {
  cy.visit('app/visualize/');
  cy.get('[data-test-subj="newItemButton"]').click();
  cy.get('[data-test-subj="visType-vega"]').forceClick();
  cy.get('[data-test-subj="visualizeSaveButton"]').forceClick();
  cy.fixture('visualizations').then((visualization) => {
    cy.get('[data-test-subj="savedObjectTitle"]').type(
      `${visualization.newVisualization.title}.${random}`
    );
    cy.get('[data-test-subj="viewDescription"]').type(
      `${visualization.newVisualization.description}.${random}`
    );
  });
  cy.get('[id="new-dashboard-option"]').forceClick();
  cy.get('[data-test-subj="confirmSaveSavedObjectButton"]').forceClick();
  cy.get('[data-test-subj="dashboardSaveMenuItem"]').click();
  cy.fixture('dashboards').then((dashboard) => {
    cy.get('[data-test-subj="savedObjectTitle"]').type(
      `${dashboard.newDashboard.title}.${random}`
    );
    cy.get('[data-test-subj="viewDescription"]').type(
      `${dashboard.newDashboard.description}.${random}`
    );
    cy.get('[data-test-subj="confirmSaveSavedObjectButton"]').forceClick();
    cy.visit('/app/dashboards/list');
    cy.contains(`${dashboard.newDashboard.title}.${random}`);
  });
});
