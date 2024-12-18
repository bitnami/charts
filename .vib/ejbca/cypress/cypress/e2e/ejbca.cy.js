/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('allows to enrol and verify certificate', () => {
  const certFile = `cypress/downloads/SuperAdmin.p12`;
  cy.task('fileExists', certFile).then((exists) => {
    // A user can only enrol once
    if (!exists) {
      cy.visit(`/ejbca/ra/enrollwithusername.xhtml?username=${Cypress.env('username')}`);
      cy.get('[name="enrollWithUsernameForm:enrollmentCode"]').type(Cypress.env('password'));
      cy.get('[name="enrollWithUsernameForm:checkButton"]').click();
      cy.fixture('certs').then((certs) => {
        cy.get('[name="enrollWithUsernameForm:selectAlgorithmOneMenu"]').select(certs.newAdminCert.algorithm);
      });
      // Clicking on the button will download the certificate, but Cypress
      // expects the page to be reloaded and fails with a timeout. We manually
      // force the reload to avoid it and then verify that the file was indeed
      // downloaded. The timeout is high to ensure the file is completely downloaded
      // before the reload (and avoid flakiness in slow clusters)
      cy.window()
        .document()
        .then(function (doc) {
          doc.addEventListener('click', () => {
            setTimeout(function () {
              doc.location.reload();
            }, 12000);
          });

          cy.get('[name="enrollWithUsernameForm:generatePkcs12"]').click();
        });
    }
    cy.readFile(certFile).should('exist');
  });
});
