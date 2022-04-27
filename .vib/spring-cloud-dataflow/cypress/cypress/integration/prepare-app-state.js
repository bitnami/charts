/// <reference types="cypress" />
import { random } from './utils';

const importAnApplication = (application) => {
  cy.visit('/dashboard');
  cy.contains('button', 'Add application(s)').click();
  cy.contains('label', application).click();
  cy.contains('.btn-primary', 'Import').click();
  cy.get('.toast-container').should('contain', 'Application(s) Imported');
};

export const importAStreamApplication = () => {
  const STREAM_APPLICATION = 'Stream application starters for Kafka/Maven';

  importAnApplication(STREAM_APPLICATION);
};

export const importATaskApplication = () => {
  const TASK_APPLICATION = 'Task application starters for Maven';

  importAnApplication(TASK_APPLICATION);
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
