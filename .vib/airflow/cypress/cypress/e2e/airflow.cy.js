/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows triggering execution of a sample DAG', () => {
  cy.login();
  cy.fixture('DAGs').then((dags) => {
    cy.visit(`dags/${dags.triggered.id}/grid`);
    cy.get('[aria-label="Trigger DAG"]').click();

    // Verify the DAG appears in the list of active jobs
    cy.visit('home?status=active');
    cy.get(`[href='/dags/${dags.triggered.id}/grid']`);
  });
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
