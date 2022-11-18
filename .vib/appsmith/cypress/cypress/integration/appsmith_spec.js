/// <reference types="cypress" />
import {
  random,
} from '../support/utils';

it('allows to log in and out', () => {
  cy.login();
  cy.get('header div[class*="profile-menu"]').click();
  cy.contains('Sign Out').click();
  cy.contains('sign in');
});

it('allows to create a new project', () => {
  cy.login();
  cy.visit('/applications');
  cy.get('button[class*="createnew"]').click();
  // We don't need a name as it already adds a random name
  cy.contains('Start from a template').click();
  cy.get('button[class*="fork-button"][tabindex="0"]').click();
  cy.contains('Added successfully');
});

it('allows to change admin settings', () => {
  cy.login();
  cy.visit(`/settings/general`);
  cy.fixture('user-settings').then(($us) => {
    cy.get('input[name*="INSTANCE_NAME"]')
      .clear()
      .type(`${$us.instanceName}-${random}`, { force: true });
    cy.contains('button', 'Save').click();
    cy.contains('successfully');
    cy.visit(`/settings/general`);
    cy.contains(`${$us.instanceName}-${random}`);
  });
});
