/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows editing the starting page', () => {
  cy.login();
  cy.visit('/start');
  cy.get('a[href="/start?do=edit"]').click({ force: true });
  cy.fixture('pages').then((page) => {
    cy.get('#wiki__text').clear().type(`${page.newPage.content}.${random}`);
    cy.contains('button', 'Save').click();
    cy.reload();
    cy.contains(`${page.newPage.content}.${random}`);
  });
});
