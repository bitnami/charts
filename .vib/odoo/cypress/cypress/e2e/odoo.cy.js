/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows installing/uninstalling an application and inviting new users', () => {
  cy.login();
  cy.get('[title="Home Menu"]').click();
  cy.contains('a', 'Apps').click();
  cy.get('[title="Sales"]').within(() => {
    cy.get('button[name="button_immediate_install"]').click();
  });

  cy.reload({timeout: 300000});

  // Perform the second login only if the #login selector is visible
  cy.get("body").then(($body) => {
      if ($body.text().includes('Log in')) {
        cy.login();
      }
  })

  cy.get('[title="Home Menu"]').click();
  cy.contains('Settings').click();
  cy.fixture('users').then((user) => {
    cy.get('.o_user_emails').type(`${random}.${user.newUser.email}`);
    cy.contains('button', 'Invite').click();
    cy.get('div[class*=invite_users]').within(() => {
      cy.contains(`${random}.${user.newUser.email}`);
    });
  });

  cy.get('[title="Home Menu"]').click();
  cy.contains('a', 'Apps').click();
  cy.get('[role="searchbox"]').type('Invoicing {enter}');
  cy.contains('1-1');
  cy.contains('[role="article"]', 'Invoicing').within(() => {
    cy.get('button[class*="dropdown-toggle"]').click({ force: true });
  });
  cy.contains('Uninstall').click({ force: true });
  cy.get('[name*="uninstall"]').click();
  cy.reload({timeout: 300000});
  cy.get('[title="Home Menu"]').click();
  cy.contains('a', 'Invoicing').should('not.exist');
});
