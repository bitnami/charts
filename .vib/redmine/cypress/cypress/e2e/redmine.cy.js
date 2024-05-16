/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows admin to create a project and an issue with file uploaded', () => {
  cy.login();
  cy.visit('/projects');
  cy.contains('New project').click();
  cy.fixture('projects').then((project) => {
    cy.get('#project_name').type(`${project.newProject.name}.${random}`);
    cy.get('#project_description').type(project.newProject.description);
    cy.get('[name="commit"]').click();
    cy.contains('Successful creation');
    cy.contains('Projects').click();
    cy.contains('.project', `${project.newProject.name}.${random}`).click();
  });
  cy.contains('Issues').click();
  cy.get('.icon-add').click();
  cy.fixture('issues').then((issue) => {
    cy.get('#issue_subject').type(`${issue.newIssue.subject}.${random}`);
    cy.get('#issue_description').type(issue.newIssue.description);
    cy.get('[type="file"]').selectFile('cypress/fixtures/issues.json');
  });
  cy.get('[name="commit"]').click();
  cy.contains('#flash_notice', 'created');
  cy.contains('issues.json').click();
  cy.fixture('issues').then((uploadedFile) => {
    cy.contains(uploadedFile.newIssue.subject);
    cy.contains(uploadedFile.newIssue.description);
  });
});
