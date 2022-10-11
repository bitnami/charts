/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows creating a folder, then upload and then download a file ', () => {
  cy.login();
  cy.get('.new').click();
  cy.contains('Folder').click();
  cy.fixture('folders').then((folder) => {
    cy.get('[value="New folder"]').type(`${folder.newFolder.name}.${random}`);
    cy.contains('Create').click();
    cy.get('span').contains(`${folder.newFolder.name}.${random}`).click();
    cy.get('.new').click();
    cy.get('[data-action="upload"]').click();
    cy.get('[type="file"]').selectFile(
      'cypress/fixtures/file_to_upload.json',
      { force: true }
    );
    cy.contains('file_to_upload').should('be.visible');
    cy.get('[href*="file_to_upload"]').within(() => {
      cy.get('[data-action="Share"]').click();
    });
    // Create a public link and try to download the file
    cy.contains('Public Links').click();
    cy.contains('Create public link').click();
    cy.get('button').contains('Share').click();
    cy.get('.linkText')
      .invoke('val')
      .should('contain', 'vmware')
      .then((link) => {
        cy.request({
          url: `${link}/download`,
        }).then((response) => {
          expect(response.body).to.contain('testJson')
        })
      });
  });
});
