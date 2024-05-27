/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows to create and publish a new post with an image', () => {
  cy.login();
  cy.visit('/ghost/#/posts');
  cy.get('span').contains('New post').click();
  cy.fixture('posts').then((posts) => {
    cy.get('textarea[placeholder="Post title"]').type(
      `${posts.newPost.title}-${random}`
    );
    cy.get('div[contenteditable="true"]').type(posts.newPost.content, {
      force: true,
    });
    cy.get('[type="file"]').selectFile(
      'cypress/fixtures/images/test_image.jpeg', {
      force: true,
    });
  });
  // Publishing a post needs 3 steps
  // Step 1: Open drop-down menu
  cy.contains('Publish').click();
  // Step 2: Select the option from the menu
  cy.get('div[class=gh-publish-cta]').within(() => {
    cy.contains('Continue').click();
  });
  // Step 3: Confirmation pop-up
  cy.get('div[class=gh-publish-cta]').within(() => {
    cy.contains('Publish').click();
  });
  cy.fixture('posts').then((posts) => {
    // Avoid new tab
    cy.contains('a', `${posts.newPost.title}-${random}`)
      .invoke('attr', 'href')
      .then((url) => {
        cy.visit(url);
        cy.contains(Cypress.env('username'));
        cy.contains(posts.newPost.content);
        cy.get(`img[alt='${posts.newPost.title}-${random}']`);
      });
  });
});
