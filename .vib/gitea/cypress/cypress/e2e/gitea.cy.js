/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import {
  random,
} from '../support/utils';

it.only('allows to create a git repository', () => {
  cy.login();
  cy.visit('/repo/create');
  cy.fixture('repo').then((repo) => {
    cy.get('[name="repo_name"]').type(`${repo.name}-${random}`, {
      force: true,
    });
  });
  cy.get('button.primary').click();
  cy.contains('touch README.md');
});
