/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

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

it('allows publishing a message to a created exchange', () => {
  cy.login();
  cy.visit('/#/exchanges');
  cy.contains('Add a new exchange').click();
  cy.fixture('exchanges').then((exchange) => {
    cy.get('[name="name"]').type(`${exchange.newExchange.name}${random}`);
    cy.get('#arguments_1_mfkey').type(exchange.newExchange.argument1);
    cy.get('#arguments_1_mfvalue').type(exchange.newExchange.argument2);
    cy.contains('Add exchange').click({ force: true });
    cy.reload();
    cy.contains('a', `${exchange.newExchange.name}${random}`).click();
  });
  cy.contains('h2', 'Publish').click();
  cy.fixture('messages').then((message) => {
    cy.get('textarea').type(message.newMessage.payload);
  });
  cy.contains('input', 'Publish').click();
  cy.contains('Message published');
});
