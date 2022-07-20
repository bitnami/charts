/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows user to log in and log out', () => {
  cy.login();
  cy.get('div.alert').should('not.exist');
  cy.get('#logout').scrollIntoView().click();
});

it('allows creating a bucket and file upload', () => {
  cy.login();
  cy.visit('buckets/add-bucket');
  cy.fixture('testdata').then((td) => {
    cy.get('#bucket-name')
      .should('be.visible')
      .type(`${td.bucketTitle}.${random}`);
  });
  cy.contains('button[type="submit"]', 'Create Bucket')
    .should('be.visible')
    .click();
  cy.fixture('testdata').then((td) => {
    cy.url().should('include', `buckets/${td.bucketTitle}`);
  });

  cy.contains('#upload-main', 'Upload').click();
  cy.contains('span', 'Upload File').should('be.visible').click();
  cy.get('div#object-list-wrapper > input[type="file"]')
    .should('not.be.disabled')
    .selectFile('cypress/fixtures/example.json', { force: true });
  cy.reload();
  cy.contains('example.json');
});

it('allows creating a user', () => {
  cy.login();
  cy.visit('identity/users');
  cy.contains('Create User');
  cy.get('[aria-label="Create User"]').click();
  cy.fixture('testdata').then((td) => {
    cy.get('#accesskey-input').type(`${td.testAccessKey}.${random}`);
    cy.get('#standard-multiline-static').type(`${td.testSecretKey}.${random}`);
  });
  cy.contains('button[type="submit"]', 'Save').click();
  cy.fixture('testdata').then((td) => {
    cy.contains(td.testAccessKey).should('be.visible');
  });
  cy.get('#accesskey-input').should('not.exist');
});

it('allows creating a group', () => {
  cy.login();
  cy.visit('identity/groups');
  cy.get('[aria-label="Create Group"]').click();
  cy.fixture('testdata').then((td) => {
    cy.get('#group-name').type(`${td.testGroupName}.${random}`);
    cy.contains('button[type="submit"]', 'Save').click();
    cy.contains(td.testGroupName);
  });
  cy.contains('div[role="dialog"]', 'Create Group').should('not.exist');
});

it('allows creating a service account and downloading credentials', () => {
  cy.login();
  cy.visit('identity/account');
  cy.get('[aria-label="Create service account"]').click();
  cy.contains('button[type="submit"]', 'Create').click();
  cy.get('#download-button').click();
  cy.readFile('cypress/downloads/credentials.json').should('exist');
});
