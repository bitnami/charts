/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows to access Administrator Control Panel', () => {
  cy.login();
  cy.contains('Administration Control Panel').click();
  // ACP requires double login
  cy.get('[type="password"]').type(Cypress.env('password'));
  cy.get('[name=login]').click();
  cy.contains('ACP Logout');
});

it('allows to create a topic', () => {
  cy.login();
  cy.get('.forumtitle').click();
  cy.contains('New Topic').click();
  cy.fixture('topics').then((topic) => {
    cy.get('[name="subject"]').type(`${topic.newTopic.subject}-${random}`);
    cy.get('#message').type(`${topic.newTopic.content} ${random}`);
    cy.contains('Attachments').click();
    cy.get('[type=file]').selectFile('cypress/fixtures/images/post_image.png', { force: true });
    cy.get('.file-uploaded');
    cy.contains('Submit').click();
    cy.visit('/search.php?search_id=newposts');
    cy.contains(`${topic.newTopic.subject}-${random}`);
  });
});
