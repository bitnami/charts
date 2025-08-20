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
    cy.get('input[placeholder*="Please enter"]').should('have.length', 4).then((elements) => {
      cy.wrap(elements.eq(0)).type(`${svc.service.host}`)
      cy.wrap(elements.eq(1)).clear().type(80);
    })
    // Submission randomly fails with network error
    let retries = 5;
    do {
      try {
        cy.get('button[type="submit"]').click();
      } catch (e) {
        if (retries === 0) {
          throw new Error('Service submit failed.');
        } else {
          cy.wait(2000);
        }
      }
    } while (--retries >= 0);

    cy.contains('Service Detail');
    cy.get('span').contains('Services').click();
    cy.get('tr').contains(`${svc.service.name}${random}`);
  });
});
