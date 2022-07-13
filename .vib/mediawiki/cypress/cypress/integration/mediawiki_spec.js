/// <reference types="cypress" />
import { random, getPageUrlFromTitle, confirmLogOut } from '../support/utils';

it('allows to log in and out', () => {
  cy.login();
  cy.contains('li', 'Preferences');
  cy.contains('Log out').click();
  confirmLogOut();
  cy.contains('You are now logged out');
});

it('allows to create user', () => {
  cy.visit('/index.php?title=Special:CreateAccount');
  cy.fixture('users').then((user) => {
    cy.get('input[id="wpName2"]').type(`${user.newUser.username}-${random}`);
    cy.get('input[id="wpPassword2"]').type(
      `${user.newUser.password}-${random}`
    );
    cy.get('input[id="wpRetype"]').type(`${user.newUser.password}-${random}`);
  });
  cy.contains('button', 'Create your account').click();
  cy.fixture('users').then((user) => {
    cy.contains(`Welcome, ${user.newUser.username}-${random}`);
  });
});

it('allows to create a new page', () => {
  cy.login();
  cy.fixture('pages').then((page) => {
    // To create a new page you can go to `wiki/ARTICLE` URL
    // and the option to create it will appear if it doesn't exist
    // Ref: https://www.mediawiki.org/wiki/Help:Starting_a_new_page#Using_the_URL
    cy.visit(getPageUrlFromTitle(`${page.newPage.title} ${random}`), {
      failOnStatusCode: false,
    });
    cy.contains('create this page').click();
    cy.contains(`Creating ${page.newPage.title} ${random}`);
    cy.get('#wpSummary').type(`${page.newPage.summary}`, { force: true });
    cy.get('#wpTextbox1').type(`${page.newPage.content}`, { force: true });
  });
  cy.get('#wpSave').click();
  cy.contains('The page has been created');
});

it('allows to upload a file', () => {
  cy.login();
  cy.visit('/wiki/Special:Upload');
  cy.get('#wpUploadFile').selectFile('cypress/fixtures/images/post_image.png', {
    force: true,
  });
  // We'll use a random fileName to bypass duplication-related errors
  cy.get('input[name="wpDestFile"]').type(`${random}.png`);
  // If Mediawiki detects that an identical file was already uploaded
  // it will ask for confirmation, requiring additional steps
  cy.get('input[name="wpIgnoreWarning"]').click();
  cy.get('input[name="wpUpload"]').click();
  cy.contains('h1', `File:${random}.png`, { matchCase: false });
});

it('allows to change users settings', () => {
  cy.login();
  cy.visit('/wiki/Special:Preferences');
  cy.fixture('user-settings').then((userSettings) => {
    cy.get('input[name="wprealname"]')
      .clear({ force: true })
      .type(`${userSettings.user.realName} ${random}`);
    cy.get('input[name="wpnickname"]')
      .clear({ force: true })
      .type(`${userSettings.user.signature}`);
  });
  cy.contains('button', 'Save').should('not.be.disabled').click();
  cy.contains('Your preferences have been saved');
});
