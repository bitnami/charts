/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows submitting a workflow using a template created from a file', () => {
  cy.visit('/workflow-templates');
  // Closes walkthrough pop-ups
  cy.get('[class="modal-close"]').click();
  cy.get('[class="modal-close"]').click();

  cy.contains('New Workflow Template').click();
  const newWorkflow = 'cypress/fixtures/workflow-template.json';
  const workflowName = `vib-testing-template-${random}`
  cy.readFile(newWorkflow).then((obj) => {
    obj.metadata.name = workflowName;
    cy.writeFile(newWorkflow, obj);
  });
  cy.get('.sliding-panel__body').should('be.visible').within(() => {
    cy.get('[type="file"]').selectFile(newWorkflow, { force: true });
    cy.contains('Create').click();
  });
  cy.get('.top-bar').first().should('be.visible').within(() => {
    cy.contains(workflowName);
  });

  cy.visit('/workflows');

  cy.contains('Submit New').click({ force: true });

  cy.get('.sliding-panel__body').should('be.visible').within(() => {
    cy.get('.select').click();
    cy.contains(workflowName).click();
    cy.contains('button', 'Submit').click();
  });
  cy.get('[class*="node Succeeded"]').click();
});
