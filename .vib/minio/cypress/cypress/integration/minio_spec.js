/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows creating a bucket, uploading and retrieving a file', () => {
  cy.login();
  cy.visit('/buckets/add-bucket');
  cy.fixture('buckets').then((buckets) => {
    cy.get('#bucket-name').type(`${buckets.newBucket.name}.${random}`);
    cy.contains('button', 'Create Bucket').click();
    cy.visit(`/buckets/${buckets.newBucket.name}.${random}/browse`);
  });

  const fileToUpload = 'example.json';
  cy.get('#upload-main').click();
  cy.contains('Upload File').click();
  cy.get('#object-list-wrapper').within(() => {
    cy.get('[type="file"]')
      .should('not.be.disabled')
      .selectFile(`cypress/fixtures/${fileToUpload}`, { force: true });
    cy.contains(fileToUpload).should('be.visible').click();
    cy.contains('Download').click({ force: true });
  });

  cy.fixture(fileToUpload).then((uploadedFile) => {
    cy.readFile(`cypress/downloads/${fileToUpload}`).then((downloadedFile) => {
      expect(downloadedFile).to.contain(uploadedFile);
    });
  });
});
