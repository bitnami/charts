/// <reference types="cypress" />

import { random, closeThePopups, skipTheWelcomeScreen } from './utils';

before(() => {
  skipTheWelcomeScreen();
});

it('allows uploading a file', () => {
  cy.get('a[data-test-subj="uploadFile"]').click();
  cy.get('input#filePicker').selectFile(
    'cypress/fixtures/test-data-to-import.ndjson',
    {
      force: true,
    }
  );
  cy.get('[data-test-subj="dataVisualizerFileOpenImportPageButton"]').click();
  cy.fixture('testdata').then((td) => {
    cy.get('[data-test-subj="dataVisualizerFileIndexNameInput"]').type(
      `${td.testIndexName}.${random}`
    );
  });
  cy.get('[data-test-subj="dataVisualizerFileImportButton"]').click();
  cy.contains('span', 'Index created').scrollIntoView();
  cy.contains('span', 'Data uploaded').scrollIntoView();
  cy.contains('span', 'Data view created');
  cy.contains(
    '[data-test-subj="dataVisualizerFileImportSuccessCallout"]',
    'Import complete'
  );
});

it('allows creating a dashboard', () => {
  cy.visit('app/dashboards/create/');
  closeThePopups();
  cy.contains('button', 'Create').forceClick();
  cy.get('[data-test-subj="dashboardSaveMenuItem"]')
    .should('have.text', 'Save')
    .forceClick();
  cy.fixture('testdata').then((td) => {
    cy.get('[data-test-subj="savedObjectTitle"]').type(
      `${td.dashboardTitle}.${random}`
    );
    cy.get('[data-test-subj="dashboardDescription"]').type(
      `${td.dashboardDescription}.${random}`
    );
  });
  cy.contains(
    '[data-test-subj="confirmSaveSavedObjectButton"]',
    'Save'
  ).forceClick(); //forcing because there is a popup we can't control
  cy.visit('/app/dashboards/list');
  cy.fixture('testdata').then((td) => {
    cy.contains(`${td.dashboardTitle}.${random}`);
  });
});

it('allows creating a visualisation', () => {
  cy.visit('app/visualize/');
  closeThePopups();
  cy.contains('button', 'Create').click();
  cy.get('[data-test-subj="visType-vega"]')
    .should('contain.text', 'Custom visualization')
    .forceClick();
  cy.contains('[data-test-subj="visualizeSaveButton"]', 'Save').forceClick();
  cy.fixture('testdata').then((td) => {
    cy.get('[data-test-subj="savedObjectTitle"]').type(
      `${td.visualizationTitle}.${random}`
    );
  });
  cy.get('[id="new-dashboard-option"]').forceClick();
  cy.contains('Save and go').forceClick();
  cy.contains('Save').click();
  cy.fixture('testdata').then((td) => {
    cy.get('[data-test-subj="savedObjectTitle"]').type(
      `${td.visualizationTitle}.${random}`
    );
    cy.get('[data-test-subj="dashboardDescription"]').type(
      `${td.dashboardDescription}.${random}`
    );
  });
  cy.contains(
    '[data-test-subj="confirmSaveSavedObjectButton"]',
    'Save'
  ).forceClick();
  cy.visit('/app/dashboards/list');
  cy.fixture('testdata').then((td) => {
    cy.contains(`${td.dashboardDescription}.${random}`);
  });
});

it('allows adding a remote cluster', () => {
  cy.visit('app/management/data/remote_clusters');
  closeThePopups();
  cy.contains('span', 'Add').forceClick();
  cy.fixture('testdata').then((td) => {
    cy.get('[data-test-subj="remoteClusterFormNameInput"]').type(
      `${td.remoteClusterName}${random}`,
      {
        force: true,
      }
    );
    cy.get('[data-test-subj="comboBoxInput"]').type(td.remoteCluster);
    cy.get('[data-test-subj="remoteClusterFormSaveButton"]').forceClick();
    cy.get('[data-test-subj="remoteClusterDetailFlyout"]').contains(
      td.remoteClusterName
    );
    cy.get('#remoteClusterDetailsFlyoutTitle').should(
      'contain.text',
      `${td.remoteClusterName}${random}`
    );
  });
});

it('allows adding of a canvas', () => {
  cy.visit('app/canvas#/');
  closeThePopups();
  cy.get('[data-test-subj="create-workpad-button"]').forceClick();
  cy.fixture('testdata').then((td) => {
    cy.get('input[value="My Canvas Workpad"]')
      .clear()
      .type(`${td.workpadName}${random}`);
  });

  cy.contains('span', 'Add element').forceClick({
    multiple: true,
  });
  cy.contains('span', 'Text').forceClick();
  cy.visit('app/canvas#/');
  cy.fixture('testdata').then((td) => {
    cy.contains(`${td.workpadName}${random}`);
  });
});
