/// <reference types="cypress" />

import { random } from '../support/utils';

it('allows login/logout', () => {
  cy.login();
  cy.get('#login_error').should('not.exist');
  cy.visit('wp-login.php?loggedout=true&wp_lang=en_US');
  cy.contains('.message', 'logged out');
});

it('allows adding a comment to the sample blogpost', () => {
  cy.visit('/');
  cy.get('.wp-block-query');
  cy.get('.wp-block-post-title a').click();

  cy.fixture('comments').then((comment) => {
    cy.get('.commentlist').should('have.length', 1);
    cy.contains('.comment-author', comment.newComment.commenter);
    cy.get('#comment').type(`${comment.newComment.comment}.${random}`);
  });
  cy.fixture('users').then((user) => {
    cy.get('#author').type(user.randomUser.userName);
    cy.get('#email').type(user.randomUser.userEmail);
  });

  cy.get('#submit').click();
  cy.contains('your comment will be visible after it has been approved');
});

it('checks if admin can create a post', () => {
  cy.login();
  cy.visit('/wp-admin/post-new.php');
  cy.get('.components-modal__header > .components-button').click();
  cy.contains('button[type="button"]', 'Publish').click();
  cy.get('h1[aria-label="Add title"]')
    .clear()
    .type(`Test Hello World!${random}`);
  cy.get('.editor-post-save-draft').click();
  cy.contains('.editor-post-saved-state', 'Saved');
});

it('shows the SMTP configuration', () => {
  cy.login();
  cy.visit('/wp-admin/admin.php?page=wp-mail-smtp');
  cy.contains('WP Mail SMTP');
  cy.contains('Email Test').click();
  cy.fixture('admins').then((admin) => {
    cy.get('#wp-mail-smtp-setting-test_email').should(
      'have.value',
      `${admin.defaultAdmin.email}`
    );
  });
});

it('allows the upload of a file', () => {
  cy.login();
  cy.visit('wp-admin/upload.php');
  cy.contains("[role='button']", 'Add New').click();
  cy.contains('[aria-labelledby]', 'Select Files');
  cy.get('input[type=file]').selectFile(
    'cypress/fixtures/images/test_image.jpeg',
    { force: true }
  );
  cy.get('.attachment');
});
