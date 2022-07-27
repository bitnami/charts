/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows to log in and out', () => {
  cy.login();
  cy.get('#current-user').click();
  cy.get('[title="Preferences"]').click();
  cy.contains('Log Out').click();
  cy.contains('button', 'Log In');
});

it('allows to create a topic', () => {
  cy.login();
  cy.contains('button', 'New Topic').click();
  cy.fixture('topics').then((topic) => {
    cy.get('#reply-title').type(`${topic.newTopic.title}-${random}`);
    cy.get('textarea').type(`${topic.newTopic.content} ${random}`);
    cy.contains('button', 'Create Topic').click();
    cy.contains('Saving').should('not.exist');
    cy.reload();
    cy.get('.topic-list').within(() => {
      cy.contains('td', `${topic.newTopic.title}-${random}`);
    });
  });
});
