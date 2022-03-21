/// <reference types="cypress" />

import { random, closeThePopups, skipTheWelcomeScreen } from './utils'

before(() => {
  skipTheWelcomeScreen()
})

it('allows uploading a file', () => {
  cy.get('a[data-test-subj="uploadFile"]').should('be.visible').click()
  cy.get(
    'input#filePicker',
  ).selectFile('cypress/fixtures/test-data-to-import.ndjson', { force: true });
  cy.get('[data-test-subj="dataVisualizerFileOpenImportPageButton"]')
    .should('be.visible')
    .click();
  cy.fixture('testdata').then((td) => {
    cy.get('[data-test-subj="dataVisualizerFileIndexNameInput"]').type(
      `${td.testIndexName}.${random}`,
    )
  })
  cy.get('[data-test-subj="dataVisualizerFileImportButton"]')
    .should('be.visible')
    .click();
  cy.get('[title="Step 2: Index created is complete"]')
    .scrollIntoView()
    .should('be.visible');
  cy.get('[title="Step 3: Data uploaded is complete"')
    .scrollIntoView()
    .should('be.visible');
  cy.get('[title="Step 4: Index pattern created is complete"]').should(
    'be.visible',
  );
  cy.get('[data-test-subj="dataVisualizerFileImportSuccessCallout"]').should(
    'exist',
  );
})

it('allows creating a dashboard', () => {
  cy.visit('app/dashboards/create/')
  closeThePopups();
  cy.contains('button', 'Create').should('be.visible').forceClick();
  cy.get('[data-test-subj="dashboardSaveMenuItem"]')
    .should('have.text', 'Save')
    .forceClick();
  cy.fixture('testdata').then((td) => {
    cy.get('[data-test-subj="savedObjectTitle"]')
      .should('be.visible')
      .type(`${td.dashboardTitle}.${random}`);
    cy.get('[data-test-subj="dashboardDescription"]').type(
      `${td.dashboardDescription}.${random}`,
    );
  })
  cy.contains(
    '[data-test-subj="confirmSaveSavedObjectButton"]',
    'Save',
  ).forceClick(); //forcing because there is a popup we can't control
  cy.visit('/app/dashboards/list');
  cy.fixture('testdata').then((td) => {
    cy.contains(`${td.dashboardTitle}.${random}`);
  })
})

it('allows creating a visualisation', () => {
  cy.visit('app/visualize/');
  closeThePopups();
  cy.contains('button', 'Create').should('be.visible').click();
  cy.get('[data-test-subj="visType-vega"]')
    .should('contain.text', 'Custom visualization')
    .forceClick();
  cy.contains('[data-test-subj="visualizeSaveButton"]', 'Save')
    .should('exist')
    .forceClick();
  cy.fixture('testdata').then((td) => {
    cy.get('[data-test-subj="savedObjectTitle"]')
      .should('exist')
      .type(`${td.visualizationTitle}.${random}`)
  });
  cy.get('[id="new-dashboard-option"]').should('exist').forceClick();
  cy.contains('Save and go').should('exist').forceClick();
  cy.contains('Save').should('exist').click();
  cy.fixture('testdata').then((td) => {
    cy.get('[data-test-subj="savedObjectTitle"]')
      .should('be.visible')
      .type(`${td.visualizationTitle}.${random}`);
    cy.get('[data-test-subj="dashboardDescription"]').type(
      `${td.dashboardDescription}.${random}`,
    );
  })
  cy.contains(
    '[data-test-subj="confirmSaveSavedObjectButton"]',
    'Save',
  ).forceClick();
  cy.visit('/app/dashboards/list');
  cy.fixture('testdata').then((td) => {
    cy.contains(`${td.dashboardDescription}.${random}`);
  })
})

it('allows adding a remote cluster', () => {
  cy.visit('app/management/data/remote_clusters');
  closeThePopups();
  cy.contains('span', 'Add').should('be.visible').forceClick();
  cy.fixture('testdata').then((td) => {
    cy.get('[data-test-subj="remoteClusterFormNameInput"]')
      .should('be.visible')
      .type(`${td.remoteClusterName}${random}`, { force: true });
    cy.get('[data-test-subj="comboBoxInput"]')
      .should('be.visible')
      .type(td.remoteCluster);
    cy.get('[data-test-subj="remoteClusterFormSaveButton"]')
      .should('be.visible')
      .forceClick();
    cy.get('[data-test-subj="remoteClusterDetailFlyout"]').contains(
      td.remoteClusterName,
    );
    cy.get('[data-test-subj="remoteClusterDetailPanelStatusValues"]').should(
      'contain.text',
      `${td.remoteClusterName}${random}`,
    );
  })
})

it('allows adding of a canvas', () => {
  cy.visit('app/canvas#/');
  closeThePopups();
  cy.get('[data-test-subj="create-workpad-button"]')
    .should('be.visible')
    .forceClick();
  cy.get('[data-test-subj="add-element-button"]')
    .should('have.text', 'Add element')
    .forceClick();
  cy.contains('span', 'Text').forceClick();
  cy.visit('app/canvas#/');
  cy.contains('My Canvas Workpad').should('be.visible');
})
