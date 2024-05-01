/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import {
  random,
} from '../support/utils';

it('allows to publish a tweet with an image', () => {
  cy.login();
  cy.get('[type="file"]').selectFile('cypress/fixtures/images/test_image.jpeg', {force: true});
  cy.fixture('tweets').then((tweet) => {
    // There is another hidden textarea so we need to use the *compose* class
    cy.get('[class*="compose"] textarea').type(`${tweet.text} ${random}`, {
      force: true,
    });
    cy.get('[type="submit"]').should('be.enabled').click();
    cy.get('.item-list').contains(`${tweet.text} ${random}`);
    // The image will get renamed so we can only check if the new post contains an image
    cy.contains('.status-public', `${tweet.text} ${random}`).within(() => {
      cy.get('[href*="jpeg"]');
    })
  });
});
