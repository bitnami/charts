/// <reference types="cypress" />

import { closeThePopups, skipTheWelcomeScreen, random } from '../support/utils';

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
  cy.fixture('indexes').then((index) => {
    cy.get('[data-test-subj="dataVisualizerFileIndexNameInput"]').type(
      `${index.newIndex.name}.${random}`
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
  cy.fixture('dashboards').then((dashboard) => {
    cy.get('[data-test-subj="savedObjectTitle"]').type(
      `${dashboard.newDashboard.title}.${random}`
    );
    cy.get('[data-test-subj="dashboardDescription"]').type(
      `${dashboard.newDashboard.description}.${random}`
    );
  });
  cy.contains(
    '[data-test-subj="confirmSaveSavedObjectButton"]',
    'Save'
  ).forceClick(); //forcing because there is a popup we can't control
  cy.visit('/app/dashboards/list');
  cy.fixture('dashboards').then((dashboard) => {
    cy.contains(`${dashboard.newDashboard.title}.${random}`);
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
  cy.fixture('visualizations').then((visualization) => {
    cy.get('[data-test-subj="savedObjectTitle"]').type(
      `${visualization.newVisualization.title}.${random}`
    );
  });
  cy.get('[id="new-dashboard-option"]').forceClick();
  cy.contains('Save and go').forceClick();
  cy.contains('Save').click();
  cy.fixture('visualizations').then((visualization) => {
    cy.get('[data-test-subj="savedObjectTitle"]').type(
      `${visualization.newVisualization.title}.${random}`
    );
    cy.get('[data-test-subj="dashboardDescription"]').type(
      `${visualization.newVisualization.description}.${random}`
    );
  });
  cy.contains(
    '[data-test-subj="confirmSaveSavedObjectButton"]',
    'Save'
  ).forceClick();
  cy.visit('/app/dashboards/list');
  cy.fixture('dashboards').then((dashboard) => {
    cy.contains(`${dashboard.newDashboard.title}.${random}`);
  });
});

it('allows adding a remote cluster', () => {
  cy.visit('app/management/data/remote_clusters');
  closeThePopups();
  cy.contains('span', 'Add').forceClick();
  cy.fixture('clusters').then((cluster) => {
    cy.get('[data-test-subj="remoteClusterFormNameInput"]').type(
      `${cluster.newCluster.name}${random}`,
      {
        force: true,
      }
    );
    cy.get('[data-test-subj="comboBoxInput"]').type(cluster.newCluster.cluster);
    cy.get('[data-test-subj="remoteClusterFormSaveButton"]').forceClick();
    cy.get('[data-test-subj="remoteClusterDetailFlyout"]').contains(
      cluster.newCluster.name
    );
    cy.get('#remoteClusterDetailsFlyoutTitle').should(
      'contain.text',
      `${cluster.newCluster.name}${random}`
    );
  });
});

it('allows adding of a canvas', () => {
  cy.visit('app/canvas#/');
  closeThePopups();
  cy.get('[data-test-subj="create-workpad-button"]').forceClick();
  cy.fixture('workpads').then((workpad) => {
    cy.get('input[value="My Canvas Workpad"]')
      .clear()
      .type(`${workpad.newWorkpad.name}${random}`);
  });

  cy.contains('span', 'Add element').forceClick({
    multiple: true,
  });
  cy.contains('span', 'Text').forceClick();
  cy.visit('app/canvas#/');
  cy.fixture('workpads').then((workpad) => {
    cy.contains(`${workpad.newWorkpad.name}${random}`);
  });
});
