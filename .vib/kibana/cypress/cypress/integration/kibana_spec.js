/// <reference types="cypress" />

import { closeThePopups, skipTheWelcomeScreen, random } from '../support/utils';

before(() => {
  skipTheWelcomeScreen();
});

it('allows uploading data', () => {
  cy.get('a[data-test-subj="uploadFile"]').click();
  cy.get('input#filePicker').selectFile(
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
  cy.contains(
    '[data-test-subj="dataVisualizerFileImportSuccessCallout"]',
    'Import complete'
  );
});

it('allows creating a dashboard and visualisation', () => {
  cy.visit('app/visualize/');
  closeThePopups();
  cy.contains('button', 'Create').click();
  cy.get('[data-test-subj="visType-vega"]').forceClick();
  cy.contains('[data-test-subj="visualizeSaveButton"]', 'Save').forceClick();
  cy.fixture('visualizations').then((visualization) => {
    cy.get('[data-test-subj="savedObjectTitle"]').type(
      `${visualization.newVisualization.title}.${random}`
    );
    cy.get('[data-test-subj="viewDescription"]').type(
      `${visualization.newVisualization.description}.${random}`
    );
  });
  cy.get('[id="new-dashboard-option"]').forceClick();
  cy.contains(
    '[data-test-subj="confirmSaveSavedObjectButton"]',
    'Save and go'
  ).forceClick();
  cy.contains('[data-test-subj="dashboardSaveMenuItem"]', 'Save').click();
  cy.fixture('dashboards').then((dashboard) => {
    cy.get('[data-test-subj="savedObjectTitle"]').type(
      `${dashboard.newDashboard.title}.${random}`
    );
    cy.get('[data-test-subj="dashboardDescription"]').type(
      `${dashboard.newDashboard.description}.${random}`
    );
    cy.contains(
      '[data-test-subj="confirmSaveSavedObjectButton"]',
      'Save'
    ).forceClick();
    cy.visit('/app/dashboards/list');
    cy.contains(`${dashboard.newDashboard.title}.${random}`);
  });
});
