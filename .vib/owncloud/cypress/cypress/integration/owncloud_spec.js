/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows creating a folder and uploading a file ', () => {
  cy.login();
  cy.get('.new').click();
  cy.contains('Folder').click();
  cy.fixture('folders').then((folder) => {
    cy.get('[value="New folder"]').type(`${folder.newFolder.name}.${random}`);
    cy.contains('Create').click();
    cy.contains(`${folder.newFolder.name}.${random}`).click();
  });
  cy.get('.new').click();
  cy.get('[data-action="upload"]').click();
  cy.get('input[type="file"]').selectFile(
    'cypress/fixtures/file_to_upload.json',
    { force: true }
  );
  cy.contains('file_to_upload').should('be.visible');
});

