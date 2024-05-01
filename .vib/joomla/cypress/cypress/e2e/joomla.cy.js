/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows creating an article and accessing it publicly', () => {
  cy.login();
  cy.visit('/administrator/index.php?option=com_content&view=articles');
  cy.get('.button-new').click();
  cy.fixture('articles').then((article) => {
    cy.get('#jform_title')
      .scrollIntoView()
      .type(`${article.newArticle.title} ${random}`, {
        force: true,
      });
    cy.contains('Content').click({ force: true });
    cy.get('.switcher > [id="jform_featured1"]').click({ force: true });
    cy.contains('Save').click();
    cy.contains('Article saved');
    cy.visit('/index.php');
    cy.contains(`${article.newArticle.title} ${random}`);
  });
});

it('allows uploading an image', () => {
  cy.login();
  cy.visit('/administrator/index.php?option=com_media');
  cy.contains('Upload').click();
  cy.get('input[type="file"]').selectFile(
    'cypress/fixtures/images/post_image.png',
    { force: true }
  );
  cy.contains('Item uploaded');
});
