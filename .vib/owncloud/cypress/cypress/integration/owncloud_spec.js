/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows creating a folder, uploading a file to it, and downloading said file ', () => {
  cy.login();
  cy.get('.new').click();
  cy.contains('Folder').click();
  cy.fixture('folders').then((folder) => {
    cy.get('[value="New folder"]').type(`${folder.newFolder.name}.${random}`);
    cy.contains('Create').click();
    cy.get('span').contains(`${folder.newFolder.name}.${random}`).click();
    cy.get('.new').click();
    cy.get('[data-action="upload"]').click();
    const fileToUpload = 'file_to_upload.json';
    cy.get('[type="file"]').selectFile(
      `cypress/fixtures/${fileToUpload}`, { force: true }
    );
    cy.contains(fileToUpload).should('be.visible');
    cy.get(`[href*="${fileToUpload}"]`).within(() => {
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
          json: true,
        }).then((response) => {
            const downloadedFile = response.body
            cy.fixture(fileToUpload).then((uploadedFile) => {
              expect(uploadedFile).to.contain(downloadedFile);
            });
          })
      });
  });
});
