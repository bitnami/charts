/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows adding a project and a quality gate', () => {
  cy.login();
  // Skip welcome tour
  cy.wait(5000);
  cy.get('body').then(($body) => {
    if ($body.find('img[src*=mode-tour]').is(':visible')) {
      cy.get('span').contains('Later').click({force: true});
      cy.get('button[data-action=skip]').click({force: true});
    }
  });
  cy.visit('/projects');
  // Step 1: Create a project
  cy.fixture('projects').then((projects) => {
    // Wait for DOM content to load
    cy.wait(5000);
    cy.get('body').then(($body) => {
      if ($body.find('#project-creation-menu-trigger').is(':visible')) {
        cy.get('#project-creation-menu-trigger').click();
      }
    });
    cy.get('[href="/projects/create?mode=manual"]').click({force: true});
    cy.get('#project-name').type(`${projects.newProject.name} ${random}`);
    cy.get('[type="submit"]').contains('Next').click();
    cy.get('span').contains('Use the global setting').click();
    cy.get('[type="submit"]').contains('Create').click();

    // Step 2: Create a Quality gate
    cy.visit('/quality_gates');
    cy.fixture('quality-gates').then((qualityGates) => {
      cy.contains('Create').click();
      cy.get('#quality-gate-form-name').type(`${qualityGates.newQualityGate.name}${random}`);
      cy.get('[type="submit"]').contains('Create').click();
      cy.contains('Unlock editing').click();
      cy.contains('Add Condition').click({force: true});
      cy.contains('Lines to Cover').click({force: true});
      cy.get('#condition-threshold').type(qualityGates.newQualityGate.threshold);
      cy.get('[type="submit"]').click();

      // Step 3: Add the project to the quality gate
      cy.contains('Without').click();
      cy.contains(`${projects.newProject.name} ${random}`).click();
      cy.contains('With').click();
      cy.contains(`${projects.newProject.name} ${random}`);
      // Check that the project really has been added
      cy.contains('Without').click();
      cy.contains(`${projects.newProject.name} ${random}`).should('not.exist');
    });
  });
});
