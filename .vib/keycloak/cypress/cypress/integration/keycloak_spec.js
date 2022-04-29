/// <reference types="cypress" />
import { random } from './utils';

it('allows login/logout', () => {
  cy.login();
  cy.get('#input-error').should('not.exist');
  cy.reload();
  cy.get('.dropdown-toggle').click({ force: true });
  cy.contains('Sign Out').click({ force: true });
  cy.contains('#kc-login', 'Sign In');
});

it('allows changing admin data', () => {
  cy.login();
  cy.get('.dropdown-toggle').click({ force: true });
  cy.contains('a', 'Manage account').click({ force: true });
  cy.contains('Account console loading').should('not.exist');
  cy.contains('a', 'Personal').click({ force: true });
  cy.fixture('admins').then((user) => {
    cy.get('#first-name').clear().type(`${user.newAdmin.firstName}.${random}`);
    cy.get('#last-name').clear().type(`${user.newAdmin.lastName}.${random}`);
    cy.get('#email-address').clear().type(`${user.newAdmin.email}`);
    cy.get('#save-btn').click();
    cy.contains('Your account has been updated');
  });
});

it('allows creating a new user', () => {
  cy.login();
  cy.get('[data-ng-show="access.queryUsers"]').click();
  cy.get('#createUser').click();
  cy.fixture('users').then((user) => {
    cy.get('#username').type(`${user.newUser.username}.${random}`);
    cy.get('#email').type(`${user.newUser.email}.${random}`);
    cy.get('#firstName').type(`${user.newUser.firstName}.${random}`);
    cy.get('#lastName').type(`${user.newUser.lastName}.${random}`);
  });
  cy.contains('button', 'Save').click();
  cy.contains('.alert', 'Success');
});

it('allows the upload and delete of a locale ', () => {
  cy.login();
  cy.contains('Localization').click();
  cy.contains('Upload localization').click();
  cy.get('input#import-file').selectFile(
    'cypress/fixtures/empty-localization-file.json',
    {
      force: true,
    }
  );
  cy.fixture('locales').then((locale) => {
    cy.get('#locale').type(`${locale.German}.${random}`);
  });
  cy.contains('button', 'Import').click();
  cy.contains('.alert', 'Success');
});

it('allows adding and removing an identity provider', () => {
  const IDENTITY_PROVIDER = 'instagram';

  cy.login();
  cy.contains('a', 'Identity Providers').click();
  cy.get('.form-group > .form-control').select(IDENTITY_PROVIDER);
  cy.fixture('identity-providers').then((identity) => {
    cy.get('#clientId').type(`${identity.identityProvider.clientId}.${random}`);
    cy.get('#clientSecret').type(
      `${identity.identityProvider.clientSecret}.${random}`
    );
  });
  cy.contains('button', 'Save').scrollIntoView().click();
  cy.contains('.alert', 'Success');
  cy.contains('a', 'Identity Providers').click();
  cy.contains('td', IDENTITY_PROVIDER).siblings('td', 'Delete').last().click();
  cy.contains('button', 'Delete').click();
});

it('allows creating a SMTP host', () => {
  cy.login();
  cy.contains('a', 'Email').click();
  cy.fixture('smtps').then((smtp) => {
    cy.get('#smtpHost').clear().type(`${smtp.smtp.host}.${random}`);
    cy.get('#smtpFrom').clear().type(`${smtp.smtp.from}`);
  });
  cy.contains('button', 'Save').click();
  cy.contains('.alert', 'Success');
});
