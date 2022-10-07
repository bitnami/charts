/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows creating a folder and uploading a file ', () => {
  cy.login();
  cy.get('.new').click();
  cy.contains('Folder').click();
  cy.fixture('folders').then((folder) => {
    cy.get('[value="New folder"]').type(`${folder.newFolder.name}.${random}`);
    cy.contains('Create').click();
    cy.get('span').contains(`${folder.newFolder.name}.${random}`).click();
    cy.contains('No files in here');
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
    cy.get('[class="permalink"]').click();
    cy.get('.detailFileInfoContainer').within(() => {
      cy.get('input')
        .invoke('val')
        .should('contain', 'vmware')
        .then((link) => {
          cy.request({
            method: 'GET',
            url: link,
            form: true,
          }).then((response) => {
              expect(response.status).to.eq(200);
            });
        });
    });
  });
});
