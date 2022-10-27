/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows deploying a healthy app for a new project', () => {
  cy.login();

  cy.visit('/settings/projects?add=true');
  cy.fixture('projects').then((projects) => {
    cy.contains('Project Name').type(`${projects.newProject.name}-${random}`);
  });
  cy.contains('button', 'Create').click();
  cy.contains('div', 'DESTINATIONS').within(() => {
    cy.contains('Edit').click();
    cy.contains('ADD DESTINATION').click();
    cy.contains('Save').click();
  });

  cy.contains('div', 'SOURCE REPOSITORIES').within(() => {
    cy.contains('Edit').click();
    cy.contains('ADD SOURCE').click();
    cy.contains('Save').click();
  });

  cy.visit('/applications');
  cy.get('[qe-id="applications-list-button-new-app"]').click({force: true});
  cy.fixture('applications').then((applications) => {
    cy.get('[qeid="application-create-field-app-name"]').type(
      `${applications.newApplication.name}-${random}`
    );
    cy.fixture('projects').then((projects) => {
      cy.get('[qe-id="application-create-field-project"]').type(
        `${projects.newProject.name}-${random}`
      );
    });
    cy.get('[qe-id="application-create-field-repository-url"]').type(
      applications.newApplication.repoUrl
    );
    cy.get('[qe-id="application-create-field-path"]').type(
      applications.newApplication.repoPath
    );
    cy.get('[qe-id="application-create-field-cluster-url"]').type(
      applications.newApplication.clusterUrl
    );
    cy.get('[qeid="application-create-field-namespace"]').type(
      applications.newApplication.namespace
    );
    cy.get('[qe-id="applications-list-button-create"]').click();

    cy.get('.applications-list').within(() => {
      cy.contains(`${applications.newApplication.name}-${random}`).click();
    });
  });
  cy.contains('Sync').click();
  cy.get('[qe-id="application-sync-panel-button-synchronize"]').click({force: true});
  cy.get('[title="Healthy"]');
});
