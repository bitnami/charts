/// <reference types="cypress" />

import { random } from '../support/utils';

it('allows creating a post with image', () => {
  cy.login();
  cy.visit('/wp-admin/post-new.php');
  cy.get('[aria-label="Close dialog"]').click();
  cy.fixture('posts').then((post) => {
    cy.get('[aria-label="Add title"]')
      .clear()
      .type(`${post.newPost.title} ${random}`);
  });
  cy.get('[aria-label*="block inserter"]').click();
  cy.get('[class*="item-image"]').click();
  cy.get('[type=file]').selectFile('cypress/fixtures/images/test_image.jpeg', {
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
