/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows uploading broker definitions', () => {
  cy.login();
  cy.contains('Import definitions').click();
  cy.get('[type="file"]').selectFile(
    'cypress/fixtures/broker-definitions.json'
  );
  cy.contains('input', 'Upload').click();
  cy.get('.form-popup-warn').should('not.exist');
  cy.contains('imported successfully');
});

it('allows adding a new queue and binding/unbinding it to the exchange', () => {
  cy.login();
  cy.visit('/#/queues');
  cy.contains('Add a new queue').click();
  cy.fixture('queues').then((queue) => {
    cy.get('[name="name"]').type(`${queue.newQueue.name}${random}`);
    cy.get('#arguments_1_mfkey').type(queue.newQueue.argument1);
    cy.get('#arguments_1_mfvalue').type(queue.newQueue.argument2);
    cy.contains('Add queue')
      .click({ force: true });
    cy.reload();
    cy.contains('table', `${queue.newQueue.name}${random}`);
  });
  cy.visit('/#/exchanges/%2F/amq.direct');
  cy.contains('Bindings').click();
  cy.fixture('queues').then((queue) => {
    cy.get('form[action*="bindings"][method*="post"]').within(() => {
      cy.get('[name="destination"]').type(`${queue.newQueue.name}${random}`);
      cy.contains('Bind').click();
    });
    cy.reload();
    cy.get(`[href*="${queue.newQueue.name}${random}"]`).click();
    cy.contains('Unbind').click({ force: true });
    cy.visit('/#/exchanges/%2F/amq.direct');
    cy.contains(`${queue.newQueue.name}${random}`).should('not.exist');
  });
});
