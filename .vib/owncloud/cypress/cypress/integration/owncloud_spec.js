/// <reference types="cypress" />
import { random } from './utils';

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
  cy.get('.subtab-publicshare').click();
  cy.get('.addLink').click();
  cy.get('.shareDialogLinkShare').then(() => {
    cy.fixture('links').then((link) => {
      cy.get('[name="linkName"]')
        .clear()
        .type(`${link.newLinks.name}0.${random}`);
    });
    cy.contains('.primary', 'Share').click();
    cy.visit('/');
    cy.contains('Shared by link').click();
    cy.contains('No files in here').should('not.be.visible');
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
