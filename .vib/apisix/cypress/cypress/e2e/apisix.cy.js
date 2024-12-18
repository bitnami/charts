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
  cy.visit('/service/list');
  // Go to the services page
  cy.get('button').contains('Create').click();
  // Create a service
  cy.fixture('service').then((svc) => {
    cy.get('#name').type(`${svc.service.name}${random}`);
    cy.get('[placeholder*="Hostname"]').type(`${random}-${svc.service.host}`)
    cy.get('button').contains('Next').click();
    cy.contains('After customizing the plugin');
    cy.get('button').contains('Next').click();
    cy.get('button').contains('Submit').click();
    cy.get('tr').contains(`${svc.service.name}${random}`);
  });
});
