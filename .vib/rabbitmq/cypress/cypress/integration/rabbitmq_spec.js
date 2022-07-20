/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows login/logout', () => {
  cy.login();
  cy.get('#versions')
    .invoke('text')
    .should('match', /RabbitMQ.*\d+\.\d+\.\d+/);
  cy.contains('RabbitMQ Management');
  cy.contains('Log out').click();
  cy.contains('#login', 'Username');
});

it('allows uploading broker definitions', () => {
  cy.login();
  cy.contains('Import definitions').click();
  cy.get('input[type="file"]').selectFile(
    'cypress/fixtures/broker-definitions.json'
  );
  cy.contains('Upload broker definitions').click();
  cy.get('.form-popup-warn').should('not.exist');
  cy.contains('Your definitions were imported successfully');
});

it('allows publishing a message to a created exchange', () => {
  cy.login();
  cy.visit('#/exchanges');
  cy.contains('Add a new exchange').click();
  cy.fixture('exchanges').then((exchange) => {
    cy.get('[name="name"]')
      .scrollIntoView()
      .type(`${exchange.newExchange.name}${random}`);
    cy.get('#arguments_1_mfkey').type(exchange.newExchange.argument1);
    cy.get('#arguments_1_mfvalue').type(exchange.newExchange.argument2);
    cy.contains('Add exchange')
      .scrollIntoView()
      .should('be.enabled')
      .click({ force: true });
    cy.reload();
    cy.get('table[class="list"]').should(
      'contain',
      `${exchange.newExchange.name}${random}`
    );
    cy.contains('a', `${exchange.newExchange.name}${random}`).click();
  });
  cy.contains('Publish message').click();
  cy.fixture('messages').then((message) => {
    cy.get('textarea')
      .should('not.be.disabled')
      .type(message.newMessage.payload);
  });
  cy.contains('input', 'Publish message').click();
  cy.contains('Message published');
});

it('allows adding a new queue and binding/unbinding it to the exchange', () => {
  cy.login();
  cy.visit('#/queues');
  cy.contains('Add a new queue').click();
  cy.fixture('queues').then((queue) => {
    cy.get('[name="name"]').type(`${queue.newQueue.name}${random}`);
    cy.get('#arguments_1_mfkey').type(queue.newQueue.argument1);
    cy.get('#arguments_1_mfvalue').type(queue.newQueue.argument2);
    cy.contains('Add queue')
      .scrollIntoView()
      .should('be.enabled')
      .click({ force: true });
    cy.reload();
    cy.contains('table', `${queue.newQueue.name}${random}`);
  });
  cy.visit('#/exchanges');
  cy.contains('amq.direct').click();
  cy.contains('Bindings').click();
  cy.fixture('queues').then((queue) => {
    cy.get('[name="destination"]').type(`${queue.newQueue.name}${random}`);
    cy.contains('[type="submit"]', 'Bind').click();
    cy.contains('.bindings-wrapper', `${queue.newQueue.name}${random}`);
  });
  cy.contains('Unbind').click();
  cy.contains('no bindings');
});

it('allows adding a new admin and logging in as such', () => {
  cy.login();
  cy.visit('/#/users');
  cy.contains('Add a user').click();
  cy.fixture('admins').then((admin) => {
    cy.get('[name="username"').type(`${admin.newAdmin.userName}${random}`);
    cy.get('[name="password"]').type(`${admin.newAdmin.password}${random}`);
    cy.get('[name="password_confirm"]').type(
      `${admin.newAdmin.password}${random}`
    );
    cy.get('#tags').type(admin.newAdmin.tags);
    cy.contains('input[type="submit"]', 'Add user').click();
    cy.get('[class="updatable"]').should(
      'contain',
      `${admin.newAdmin.userName}${random}`
    );
    cy.contains('Log out').click();
    cy.get('[alt="RabbitMQ logo"]');
    cy.get('[name="username"]').type(`${admin.newAdmin.userName}${random}`);
    cy.get('[name="password"]').type(`${admin.newAdmin.password}${random}`);
    cy.contains('Login').click();
    cy.get('#versions')
      .invoke('text')
      .should('match', /RabbitMQ\s\d+\.\d+\.\d+/);
    cy.contains('Log out');
  });
});
