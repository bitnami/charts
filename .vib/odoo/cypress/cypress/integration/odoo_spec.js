/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows installing/uninstalling an application', () => {
  cy.login();
  cy.get('[title="Home Menu"]').click();
  cy.contains('a', 'Apps').click();
  cy.get('[title="Sales"]').within(() => {
    cy.contains('Install').click();
  });
  cy.reload();

  cy.get('[title="Home Menu"]').click();
  cy.contains('a', 'Apps').click();
  cy.get('[role="searchbox"]').type('Discuss {enter}');
  cy.contains('[role="article"]', 'Discuss').within(() => {
    cy.get('a[title*="menu"]').click({ force: true });
  });
  cy.contains('Uninstall').click({ force: true });
  cy.contains('Confirm').click();
  cy.reload();

  cy.get('[title="Home Menu"]').click();
  cy.contains('a', 'Discuss').should('not.exist');
});

it('allows inviting new users', () => {
  cy.login();
  cy.get('[title="Home Menu"]').click();
  cy.contains('Settings').click();
  cy.fixture('users').then((user) => {
    cy.get('.o_user_emails').type(`${random}.${user.newUser.email}`);
    cy.contains('button', 'Invite').click();
    cy.get('#invite_users_setting').within(() => {
      cy.contains(`${random}.${user.newUser.email}`);
    });
  });
});
