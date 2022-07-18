/// <reference types="cypress" />
import { random } from '../support/utils.js';
import {
  importAnApplication,
  createATask,
} from '../support/prepare_app_state.js';

it('allows getting Spring Cloud Dataflow info', () => {
  cy.visit('/dashboard');
  cy.get('.signpost-trigger').click();
  cy.get('.signpost-content-body')
    .invoke('text')
    .should('match', /.*[0-9].*/);
  cy.contains('button', 'More info').click();
  cy.contains('.modal-content', 'Core')
    .and('contain', 'Dashboard')
    .and('contain', 'Shell');
});

it('allows a stream to be created and deployed', () => {
  cy.fixture('applications').then((application) => {
    importAnApplication(application.newApplication.streamApplicationType);
  });
  cy.visit('dashboard/#/streams/list');
  cy.contains('button', 'Create stream(s)').click();
  cy.fixture('streams').then((stream) => {
    cy.get('.CodeMirror-line').type(stream.newStream.type);
  });

  cy.fixture('applications').then((application) => {
    cy.contains('#v-2', application.newApplication.streamApplication1).and(
      'contain',
      application.newApplication.streamApplication2
    );
  });

  cy.contains('button', 'Create stream(s)').click();
  cy.get('.modal-content').should('contain', 'Create Stream');
  cy.fixture('streams').then((stream) => {
    cy.get('input[placeholder="Stream Name"]').type(
      `${stream.newStream.name}-${random}`
    );
    cy.contains('button', 'Create the stream').click();
    cy.contains(
      '.datagrid-inner-wrapper',
      `${stream.newStream.name}-${random}`
    );
    cy.contains('.toast-container', 'successfully');
    cy.contains('clr-dg-cell', 'UNDEPLOYED')
      .siblings('clr-dg-cell', stream.newStream.name)
      .first()
      .click();
  });

  cy.contains('button#btn-deploy', 'Deploy stream').click();
  cy.contains('button', 'Deploy stream').click();
  cy.get('.toast-container').should('contain', 'Deploy success');
});

it('allows a task to be scheduled and destroyed', () => {
  cy.fixture('applications').then((application) => {
    importAnApplication(application.newApplication.taskApplicationType);
  });
  cy.fixture('schedules').then((schedule) => {
    createATask(schedule.newSchedule.taskType);
  });
  cy.visit('dashboard/#/tasks-jobs/tasks');
  cy.fixture('tasks').then((task) => {
    cy.contains('clr-dg-cell', 'UNKNOWN')
      .siblings('clr-dg-cell', task.newTask.name)
      .first()
      .click();
  });
  cy.contains('button', 'Schedule').click();
  cy.fixture('schedules').then((schedule) => {
    cy.get('input[name="example"]')
      .first()
      .type(`${schedule.newSchedule.name}-${random}`);

    cy.get('input[name="example"]')
      .last()
      .type(`${schedule.newSchedule.cronExpression}`);
  });

  cy.contains('button', 'Create schedule(s)').click();
  cy.contains('.toast-container', 'Successfully');
  cy.contains('a', 'Tasks').click();
  cy.contains('clr-dg-cell', 'UNKNOWN')
    .siblings('clr-dg-cell', 'test-task-')
    .first()
    .click();
  cy.contains('button', 'Destroy task').click();
  cy.contains('button', 'Destroy the task').click();
  cy.contains('1 task definition(s) destroyed.');
});

it('allows importing a task from a file and destroying it ', () => {
  cy.visit('/dashboard/#/manage/tools');
  cy.contains('a', 'Import tasks from a JSON file').click();
  cy.get('input[type="file"]').selectFile(
    'cypress/fixtures/task-to-import.json',
    { force: true }
  );
  cy.contains('button', 'Import').click();
  cy.contains('1 task(s) created');
  cy.get('.close').click();
  cy.visit('dashboard/#/tasks-jobs/tasks');
  cy.contains('button', 'Group Actions').click();
  cy.get('[aria-label="Select All"]').click({ force: true });
  cy.contains('button', 'Destroy task').click();
  cy.contains('.modal-content', 'Confirm Destroy Task');
  cy.contains('button', 'Destroy the task').click();
  cy.get('.toast-container').should('contain', 'destroyed');
});

it('allows unregistering of an application', () => {
  cy.fixture('applications').then((application) => {
    importAnApplication(application.newApplication.streamApplicationType);
  });
  cy.get('clr-dg-cell').siblings('clr-dg-cell', 'PROCESSOR').first().click();
  cy.contains('button', 'Unregister Application').click();
  cy.contains('button', 'Unregister the application').click();
  cy.contains('Successfully removed app');
});
