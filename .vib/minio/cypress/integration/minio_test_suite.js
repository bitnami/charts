/// <reference types="cypress" />
import {
  random,
} from './utils'

it('allows user to log in and log out', () => {
  cy.login();
  cy.get('[data-testid="ErrorOutlineIcon"]').should('not.exist');
  cy.get("#logout").should('exist').click();
  })

it('allows creating a bucket and file upload', () => {
  const BUCKET_TITLE = 'testbucket'
  
  cy.login();
  cy.visit('/add-bucket');
  cy.get('#bucket-name').should('be.visible').type(`${BUCKET_TITLE}.${random}`);
  cy.contains('button[type="submit"]','Create Bucket').click();
  cy.contains('#upload-main','Upload').should('be.visible').click();
  cy.contains('span','Upload File').should('be.visible').click();
  cy.get('div#object-list-wrapper > input[type="file"]').selectFile('cypress/fixtures/example.json',
  {force:true});
  })

  it('allows creating a user', () => {
    const TEST_ACCESS_KEY = 'Test Access Key';
    const TEST_SECRET_KEY = 'Secret key';

    cy.login();
    cy.visit('identity/users');
    cy.get('[aria-label="Create User"]').should('be.visible').click();
    cy.get('#accesskey-input').should('be.visible').type(`${TEST_ACCESS_KEY}.${random}`);
    cy.get('#standard-multiline-static').should('be.visible').type(`${TEST_SECRET_KEY}.${random}`);
    cy.contains('button[type="submit"]','Save').should('be.visible').click();
    cy.contains(TEST_ACCESS_KEY).should('be.visible');
  })


