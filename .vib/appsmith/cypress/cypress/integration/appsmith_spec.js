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
  cy.get('button[class*="createnew"]').click();
  // We don't need a name as it already adds a random name
  cy.contains('Widgets');
  // There is a pop-up (when there is a new version available) that takes some
  // animation to appear, but when it does, it blocks a button. We need to wait
  // a few seconds to let it appear and then remove it so we can continue
  cy.wait(2000)
  cy.get('body').then(($body) => {
    // Close the pop-up if appears
    if ($body.find('[class*="toast-action"]').is(':visible')) {
      cy.get('[class*="toast-action"]').click();
    }
  });
  cy.contains('template').click();
  cy.get('button[class*="fork-button"][tabindex="0"]').first().click();
  cy.contains('Marketing');
});

it('allows to change admin settings', () => {
  cy.login();
  cy.visit(`/settings/general`);
  cy.fixture('user-settings').then(($us) => {
    cy.get('input[name*="INSTANCE_NAME"]')
      .clear()
      .type(`${$us.instanceName}-${random}`, { force: true });
    cy.contains('button', 'Save').click();
    cy.contains('Successfully');
  });
});
