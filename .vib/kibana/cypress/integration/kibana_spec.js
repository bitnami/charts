/// <reference types="cypress" />

import {
    random,
    skipTheWelcomeScreen,
    importTestData,
    closeTheSecurityWarnings,
    dragAndDrop
  } from './utils'
  
it('allows for file upload', () => {
    
    const TEST_INDEX_NAME = 'test_index';
    skipTheWelcomeScreen();
    cy.visit('/')
    cy.get('a[data-test-subj="uploadFile"]').should('be.visible').click();
    cy.get('input#filePicker').selectFile('cypress/fixtures/test-data-to-import.ndjson',{force:true});
    cy.get('button[data-test-subj="dataVisualizerFileOpenImportPageButton"]').should('be.visible').click();
    cy.get('input[data-test-subj="dataVisualizerFileIndexNameInput"]').type(`${TEST_INDEX_NAME}.${random}`);
    cy.get('button[data-test-subj="dataVisualizerFileImportButton"]').should('be.visible').click();
    cy.get('[data-test-subj="dataVisualizerFileImportSuccessCallout"]').should('be.visible');
})

it('can add an integration ', () => {
  cy.visit('app/integrations/browse');
  cy.get('div[data-test-subj="integration-card:epr:apm:featured"]').should('be.visible').click();
  cy.contains('span[class="euiButton__text"]','Launch APM').click({force:true});
})

it('can create a dashboard ', () => {
  cy.visit('app/dashboards/create');
  cy.get('button[data-test-subj="newItemButton"]').should('be.visible').click();
  cy.get('button[data-test-subj="dashboardAddNewPanelButton"]').should('be.visible').click();
  cy.get('button[aria-controls="lnsIndexPatternEmptyFields"]').should('be.visible').click();
})



    