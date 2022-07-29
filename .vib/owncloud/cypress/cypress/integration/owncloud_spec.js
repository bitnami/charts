/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows creating a folder and uploading a file ', () => {
  cy.login();
  cy.get('.new').click();
  cy.get('[data-action="folder"]').click();
  cy.fixture('folders').then((folder) => {
    cy.get('[value="New folder"]').type(`${folder.newFolder.name}.${random}`);
    cy.contains('Create').click();
    cy.contains('.innernametext', `${folder.newFolder.name}.${random}`).click();
  });
  cy.get('.new').click();
  cy.get('[data-action="upload"]').click();
  cy.get('input[type="file"]').selectFile(
    'cypress/fixtures/file_to_upload.json',
    { force: true }
  );
  cy.contains('No files in here').should('not.be.visible');
});

it('allows adding a group and a user', () => {
  cy.login();
  cy.visit('/index.php/settings/users');
  cy.contains('Add Group').click();
  cy.fixture('groups').then((group) => {
    cy.get('#newgroupname').type(`${group.newGroup.name}.${random}`);
    cy.get('#newgroup-form').within(() => {
      cy.get('[type="submit"]').click();
    });
    cy.contains('.groupname', `${group.newGroup.name}.${random}`);
  });
  cy.fixture('users').then((user) => {
    cy.get('#newusername').type(`${user.newUser.name}.${random}`);
    cy.get('#newemail').type(`${user.newUser.email}.${random}`);
    cy.contains('Create').click();
    cy.contains('.name', `${user.newUser.name}.${random}`);
  });
});

it('checks the SMTP configuration', () => {
  cy.login();
  cy.visit('/index.php/settings/admin?sectionid=general');
  cy.get('#mail_smtphost').should('have.value', Cypress.env('smtpHost'));
  cy.get('#mail_smtpname').should('have.value', Cypress.env('smtpUser'));
  cy.get('#mail_to_address').should('have.value', Cypress.env('owncloudEmail'));
});

it('allows sharing a file by link', () => {
  cy.login();
  cy.get('[data-file="ownCloud Manual.pdf"]').within(() => {
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

it('allows whitelisting a domain', () => {
  cy.login();
  cy.visit('/index.php/settings/personal');
  cy.contains('Security').click();
  cy.fixture('domains').then((domain) => {
    cy.get('#domain').type(`${domain.newDomain.domain}`);
    cy.get('#corsAddNewDomain').click();
    cy.contains('.grid', `${domain.newDomain.domain}`);
  });
});
