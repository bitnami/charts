/// <reference types="cypress" />
import {
  random,
} from '../support/utils';

it('allows to create a new project', () => {
  cy.login();
  cy.get('[class*="createnew"]').click();
  // We don't need a name as it already adds a random name
  cy.contains('Widgets');
  // There is a pop-up (when there is a new version available) that takes some
  // animation to appear, but when it does, it blocks a button. We need to wait
  // a few seconds to let it appear and then remove it so we can continue
  cy.get('body').then(($body) => {
    // Close the pop-up if appears
    if ($body.find('[class*="toast-action"]').is(':visible')) {
      cy.get('[class*="toast-action"]').click();
    }
  });
  cy.contains('template').click({force: true});
  cy.contains('[data-cy="template-card"]', 'Marketing Portal').within(() => {
    cy.get('[class*="fork-button"]').click();
  })
  cy.contains('Marketing Portal');
  cy.contains('Deploy').click();
  // This will open a new window, but we can use the following workaround to see the page
  cy.get('[class*="deploy-popup"]').click();
  cy.get('[class*="current-deployed"]').invoke('removeAttr', 'target').click()
  // We check that the expected exist but also a button not present in the edition UI
  cy.contains('Marketing Portal');
  cy.contains('Edit App');
});

it('allows to change workspace settings', () => {
  cy.login();
  cy.get('span[class*="workspace-name"]').click();
  cy.get('[data-cy*="workspace-setting"]').click();
  cy.fixture('user-settings').then(($us) => {
    cy.get('input[placeholder="Workspace Name"]')
      .clear()
      .type(`${$us.instanceName}-${random}`, { force: true });
    cy.get('h2').contains(`${$us.instanceName}-${random}`);
  });
});
