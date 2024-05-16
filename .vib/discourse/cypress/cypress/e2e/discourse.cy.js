/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows to sign up', () => {
  cy.visit('/');
  cy.contains('button', 'Sign Up').click();
  cy.fixture('users').then((user) => {
    cy.get('#new-account-email').type(`${random}.${user.newUser.email}`);
    cy.get('#new-account-username').type(`${random}.${user.newUser.username}`);
    cy.get('#new-account-name').type(`${user.newUser.name} ${random}`);
    cy.get('#new-account-password').type(`${random}.${user.newUser.password}`);
  });
  cy.contains('Checking username').should('not.exist');
  cy.contains('button', 'Create your account').click();
  cy.contains('button', 'Resend Activation Email');
});

it('allows to create a topic', () => {
  cy.login();
  cy.contains('button', 'New Topic').click();
  cy.fixture('topics').then((topic) => {
    cy.get('#reply-title').type(`${topic.newTopic.title}-${random}`);
    cy.get('textarea').type(`${topic.newTopic.content} ${random}`);
    cy.contains('button', 'Create Topic').click();
    cy.contains('Saving').should('not.exist');
    cy.visit('/latest');
    cy.get('.topic-list').within(() => {
      cy.contains('td', `${topic.newTopic.title}-${random}`);
    });
  });
});
