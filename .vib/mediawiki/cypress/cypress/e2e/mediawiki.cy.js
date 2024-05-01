/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random, getPageUrlFromTitle, confirmLogOut } from '../support/utils';

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
  cy.get('#wpUploadFile').selectFile('cypress/fixtures/images/test_image.jpeg', {
    force: true,
  });
  // We'll use a random fileName to bypass duplication-related errors
  cy.get('[name="wpDestFile"]').clear().type(`testfile-${random}.jpeg`);
  // If Mediawiki detects that an identical file was already uploaded
  cy.get('[name="wpIgnoreWarning"]').click();
  cy.get('[name="wpUpload"]').click();
  cy.contains(`File:testfile-${random}.jpeg`, { matchCase: false });
});

