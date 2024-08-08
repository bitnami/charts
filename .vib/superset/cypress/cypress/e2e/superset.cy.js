/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

it('Example dashboards visible', () => {
  cy.login();
  cy.visit(`dashboard/list`);
  // Retries required to ensure examples finished loading
  const max_attempts = 4;
  let runFound = false;
  for (let i = 0; i < max_attempts && !runFound; i += 1) {
    cy.get('body').then(($body) => {
      if ($body.find('a[href*="/dashboard/births/"]').length === 0) {
        // run job has not finished executing, so we wait and reload the page
        runFound = true;
      } else {
        cy.wait(5000);
        cy.reload();
      }
    });
  }
  // Navigate Dashboards list
  cy.contains('USA Births Names').click();
  // Check Dashboard contains data
  cy.wait(5000);
  cy.contains('Michael');
});

it('allows to create a user', () => {
  cy.login();
  cy.visit('users/add');
  cy.fixture('users').then((users) => {
    cy.get('#first_name').type(users.newUser.firstName);
    cy.get('#last_name').type(users.newUser.lastName);
    cy.get('#username').type(`${users.newUser.username}.${random}`);
    cy.get('#email').type(`${users.newUser.username}.${random}@email.com`);
    cy.get('input[type="search"]').type(`${users.newUser.role}{enter}`);
    cy.get('#password').type(users.newUser.password);
    cy.get('#conf_password').type(users.newUser.password);
    cy.contains('Save').click();

    // Verify the user was created successfully
    cy.contains('div', 'Added Row');
  });
});
