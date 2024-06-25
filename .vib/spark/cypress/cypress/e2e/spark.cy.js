/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

/// <reference types="cypress" />

it('checks if the amount of workers is correct', () => {
  cy.visit('/');
  cy.contains(`Alive Workers: ${Cypress.env('expectedWorkers')}`);
});
