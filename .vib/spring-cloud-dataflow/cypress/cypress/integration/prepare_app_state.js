/// <reference types="cypress" />
import { random } from './utils';

export const importAnApplication = (application) => {
  cy.visit('/dashboard');
  cy.contains('button', 'Add application(s)').click();
  cy.contains('label', application).click();
  cy.contains('.btn-primary', 'Import').click();
  cy.get('.toast-container').should('contain', 'Application(s) Imported');
};

export const createATask = (taskType) => {
  cy.visit('/dashboard/#/tasks-jobs/tasks');
  cy.contains('button', 'Create task').click();
  cy.get('.CodeMirror-line').type(taskType);
  cy.contains('#v-2', taskType);
  cy.contains('button', 'Create task').click();
  cy.contains('.modal-content', 'Create task');
  cy.fixture('tasks').then((task) => {
    cy.get('input[placeholder="Task Name"]').type(
      `${task.newTask.name}-${random}`
    );
    cy.get('input#desc').type('This is a task');
    cy.contains('button', 'Create the task').click();
  });
};
