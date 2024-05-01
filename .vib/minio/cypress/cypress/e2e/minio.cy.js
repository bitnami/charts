/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';
it('allows creating a bucket, uploading and retrieving a file', () => {
  cy.login();
  cy.visit(`/buckets/add-bucket`);
  let bucketName='';
  cy.fixture('buckets').then((buckets) => {
    bucketName=`${buckets.newBucket.name}.${random}`;
    cy.get('#bucket-name').type(`${bucketName}`);
    cy.contains('button', 'Create Bucket').click();
    cy.visit(`/browser/${bucketName}`);
  });

  const fileToUpload = 'example.json';
  cy.get('#upload-main').click();
  // Once the main button is clicked a tooltip overlaps with 'Upload File' button
  cy.contains('Upload File').click({ force: true });
  cy.get('#object-list-wrapper').within(() => {
    cy.get('[type="file"]')
      .should('not.be.disabled')
      .selectFile(`cypress/fixtures/${fileToUpload}`, { force: true });
  });

  cy.fixture(fileToUpload).then((uploadedFile) => {
    cy.request(`/api/v1/buckets/${bucketName}/objects/download?prefix=${Buffer.from(fileToUpload).toString('base64')}`).then((response) => {
      cy.writeFile(`cypress/downloads/${fileToUpload}`, response.body)
    })
    cy.readFile(`cypress/downloads/${fileToUpload}`).then((downloadedFile) => {
      expect(downloadedFile).to.contain(uploadedFile);
    });
  });
});
