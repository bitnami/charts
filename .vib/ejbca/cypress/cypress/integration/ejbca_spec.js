/// <reference types="cypress" />

it('allows to enrol and verify certificate', () => {
  const certFile = `cypress/downloads/${Cypress.env('username')}.p12`;
  cy.task('fileExists', certFile).then((exists) => {
    // A user can only enrol once
    if (!exists) {
      cy.visit('/ejbca/enrol/keystore.jsp');
      cy.get('#textfieldusername').type(Cypress.env('username'));
      cy.get('#textfieldpassword').type(Cypress.env('password'));
      cy.get('#buttonsubmitusername').click();
      cy.fixture('certs').then((certs) => {
        cy.get('#tokenKeySpec').select(certs.newAdminCert.cipherSpec);
        cy.get('#certprofile').select(certs.newAdminCert.profile);
      });
      // Clicking on the button will download the certificate, but Cypress
      // expects the page to be reloaded and fails with a timeout. We manually
      // force the reload to avoid it and then verify that the file was indeed
      // downloaded.
      cy.window()
        .document()
        .then(function (doc) {
          doc.addEventListener('click', () => {
            setTimeout(function () {
              doc.location.reload();
            }, 2000);
          });

          cy.contains('input', 'Enroll').click();
        });
    }
    cy.readFile(certFile).should('exist');
  });

  cy.visit('/ejbca/retrieve/list_certs.jsp');
  cy.get('#subject').type(`${Cypress.env('baseDN')},CN=SuperAdmin`);
  cy.get('#ok').click();
  cy.contains('Check if certificate is revoked').click();
  cy.contains('has NOT been revoked');
});
