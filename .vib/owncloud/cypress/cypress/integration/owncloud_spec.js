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
});

it('allows adding a group and a user', () => {
  cy.login();
  cy.get('#expand').click();
  cy.contains('Users').click();
  cy.contains('Add Group').click();
  cy.fixture('groups').then((group) => {
    cy.get('#newgroupname').type(`${group.newGroup.name}.${random}`);
    cy.get('.icon-add').click();
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
  cy.visit('index.php/settings/admin?sectionid=general');
  cy.get('#mail_smtphost').should('have.value', Cypress.env('smtpHost'));
  cy.get('#mail_smtpname').should('have.value', Cypress.env('smtpUser'));
  cy.get('#mail_to_address').should('have.value', Cypress.env('owncloudEmail'));
});

it('allows modifying sharing settings', () => {
  cy.login();
  cy.visit('index.php/settings/personal');
  cy.contains('Sharing').click();
  cy.get('[for="allow_share_dialog_user_enumeration_input"]').click();
  cy.contains('General').click();
  cy.contains('Sharing').click();
  cy.get('#allow_share_dialog_user_enumeration_input').should('not.be.checked');
  cy.get('[for="allow_share_dialog_user_enumeration_input"]').click();
});

it('allows whitelisting a domain', () => {
  cy.login();
  cy.visit('index.php/settings/personal');
  cy.contains('Security').click();
  cy.fixture('domains').then((domain) => {
    cy.get('#domain').type(`${domain.newDomain.domain}`);
    cy.get('#corsAddNewDomain').click();
    cy.contains('.grid', `${domain.newDomain.domain}`);
  });
});
