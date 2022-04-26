/// <reference types="cypress" />
import { random } from './utils';

export const importAStreamApplication = () => {
  cy.visit('/dashboard');
  cy.contains('button', 'Add application(s)').click();
  cy.contains(
    '.clr-control-label',
    'Stream application starters for Kafka/Maven'
  ).click();
  cy.contains('.btn-primary', 'Import').click();
  cy.get('.toast-container').should('contain', 'Application(s) Imported');
  cy.get('.content-area')
    .should('contain', 'processor')
    .and('contain', 'sink')
    .and('contain', 'source');
};

export const importATaskApplication = () => {
  cy.visit('/dashboard');
  cy.contains('button', 'Add application(s)').click();
  cy.contains(
    '.clr-control-label',
    'Task application starters for Maven'
  ).click();
  cy.contains('.btn-primary', 'Import').click();
  cy.get('.toast-container').should('contain', 'Application(s) Imported');
  cy.get('[routerlink="tasks-jobs/tasks"]').click();
  cy.contains('button', 'Create task').click();
  cy.get('.content-area')
    .should('contain', 'timestamp')
    .and('contain', 'timestamp-batch');
};

export const createATask = () => {
  const TASK_TYPE = 'timestamp';

  cy.visit('/dashboard');
  cy.get('[routerlink="tasks-jobs/tasks"]').click();
  cy.contains('.btn-primary', 'Create task').click();
  cy.get('.CodeMirror-line').type(TASK_TYPE);
  cy.contains('#v-2', TASK_TYPE);
  cy.contains('button', 'Create task').click();
  cy.contains('.modal-content', 'Create task');
  cy.fixture('tasks').then((task) => {
    cy.get('input[placeholder="Task Name"]').type(
      `${task.newTask.name}-${random}`
    );
    cy.get('input#desc').type('This is a task');
    cy.contains('.btn-primary', 'Create the task').click();
  });
};
