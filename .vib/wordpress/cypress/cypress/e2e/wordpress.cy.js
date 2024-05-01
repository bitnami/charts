/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

import { random, getIframeBody } from '../support/utils';

it('allows creating a post with image', () => {
  cy.login();
  cy.visit('/wp-admin/post-new.php');
  cy.get('[aria-label="Close"]').click();
  // Wait for DOM content to load
  cy.wait(5000);
  cy.fixture('posts').then((post) => {
    console.log(getIframeBody());
    getIframeBody()
      .find('[aria-label="Add title"]')
      .should('be.visible')
      .type(`${post.newPost.title} ${random}`);
  });
  cy.get('[aria-label*="block inserter"]').click();
  cy.get('[class*="item-image"]').click();
  getIframeBody()
    .find('input[type="file"]')
    .selectFile('cypress/fixtures/images/test_image.jpeg', {
      force: true,
    });
  cy.contains('Save draft').click();
  cy.contains('Publish').click();
  cy.get(
    '.editor-post-publish-panel__header-publish-button > .components-button'
  )
    .should('not.be.disabled')
    .click();
  cy.contains('View Post').click();
  cy.get('[src*="test_image"]');
});
