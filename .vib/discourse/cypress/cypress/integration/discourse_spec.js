/// <reference types="cypress" />
import { random } from './utils';

it('allows to log in and out', () => {
  cy.login();
  cy.contains('a', 'Unread');
  cy.get('#current-user').click();
  cy.get('[title="Preferences"]').click();
  cy.contains('Log Out').click();
  cy.contains('button', 'Log In');
});

it('allows to sign up', () => {
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
    cy.get('[id="reply-title"]').type(`${topic.newTopic.title}-${random}`);
    cy.get('textarea').type(`${topic.newTopic.content} ${random}`);
    cy.contains('button', 'Create Topic').click();
    cy.contains('Saving').should('not.exist');
    cy.reload();
    cy.get('[class*="topic-list"]').within(() => {
      cy.contains('td', `${topic.newTopic.title}-${random}`);
    });
  });
});

it('allows to modify user settings', () => {
  cy.login();
  cy.visit('/u/user/preferences/account');
  cy.fixture('user-settings').then((userSettings) => {
    cy.get('[class*="pref-name"]').within(() => {
      cy.get('input')
        .clear({ force: true })
        .type(`${userSettings.user.realName} ${random}`);
    });
    cy.contains('button', 'Save Changes').click();
    cy.contains('Saved');
    cy.contains('h2', `${userSettings.user.realName} ${random}`);
  });
});

it('checks sideqik and discourse status', () => {
  const PROCESS_NAME = 'discourse';

  cy.login();
  cy.visit('/sidekiq/busy');
  cy.get('[class*="processes"]').within(() => {
    cy.contains('td', PROCESS_NAME);
  });
});
