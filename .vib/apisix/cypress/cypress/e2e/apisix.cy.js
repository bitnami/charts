/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import {
  random,
} from '../support/utils';

it('allows to create a service in the dashboard', () => {
  cy.login();
  // Go to the services page
  cy.get('span').contains('Services').click();
  // Create a service
  cy.fixture('service').then((svc) => {
    cy.get('button').contains('Add Service').click();
    cy.get('[name="name"]').type(`${svc.service.name}${random}`);
    cy.get('button').contains('Add a Node').click();
    cy.get('[name="name"]').type(`${svc.service.name}${random}`);
    cy.get('[placeholder*="Please enter" type="text"]').type(`${svc.service.host}`)
    cy.get('[placeholder*="Please enter" value="1"]').clear().type(80);
    cy.get('button[type="submit"]').click();
    cy.contains('Service Detail');
    cy.get('span').contains('Services').click();
    cy.get('tr').contains(`${svc.service.name}${random}`);
  });
});
