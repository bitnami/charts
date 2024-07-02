/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows running the movie-graph test', () => {
  cy.login();
  cy.get('div#monaco-main-editor').type(':play movie-graph{enter}');
  cy.wait(1000);
  cy.get('button[data-testid="nextSlide"]').click();
  cy.wait(1000);
  cy.get('pre[class*="runnable"]').click();
  cy.get('div#monaco-main-editor').type('{ctrl}{enter}');
  cy.get('g[class*="node"]');
});

it('allows to create a user', () => {
  cy.login();
  cy.fixture('users').then((users) => {
    cy.get('div#monaco-main-editor').type(`CREATE USER ${users.newUser.username}${random} IF NOT EXISTS SET PLAINTEXT PASSWORD '${users.newUser.password}'{enter}`);
    cy.contains('1 system update');
    cy.get('div#monaco-main-editor').type(`SHOW USERS{enter}`);
    cy.contains('td', `${users.newUser.username}${random}`);
  });
});
