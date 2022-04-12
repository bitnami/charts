/// <reference types="cypress" />
import { random } from './utils';

it('allows triggering execution of a sample DAG', () => {
  cy.login();
  cy.fixture('DAGs').then((dags) => {
    const TRIGGERED_OK_MESSAGE = `Triggered ${dags.triggered.id}, it should start`;

    cy.get('#dag_query').clear().type(`${dags.triggered.id}{enter}`);
    cy.get(`a[href="/tree?dag_id=${dags.triggered.id}"]`).click();
    cy.get('a[aria-label="Trigger DAG"]').click();
    cy.contains('button', 'Trigger DAG').click(); // A dropdown appears and clicking again is needed
    cy.get('.alert-message').should('contain.text', TRIGGERED_OK_MESSAGE);
  });

  // Verify the DAG appears in the list of active jobs
  cy.visit('home?status=active');
  cy.get('span[class="switch"]').should('have.length', 1);
});

it('checks configuration is not exposed', () => {
  const SEC_NOTICE =
    'Your Airflow administrator chose not to expose the configuration, most likely for security reasons';

  cy.login();
  cy.visit('configuration');
  cy.contains(SEC_NOTICE);
});

it('allows to create a user', () => {
  cy.login();
  cy.visit('users/add');
  cy.fixture('users').then((users) => {
    cy.get('input#first_name').type(users.newUser.firstName);
    cy.get('input#last_name').type(users.newUser.lastName);
    cy.get('input#username').type(`${users.newUser.username}.${random}`);
    cy.get('input#email').type(`${users.newUser.username}.${random}@email.com`);
    cy.get('#s2id_autogen1').type(`${users.newUser.role}{enter}`);
    cy.get('input#password').type(users.newUser.password);
    cy.get('input#conf_password').type(users.newUser.password);
    cy.contains('Save').click();
    // Verify the user was created successfully
    cy.get('.alert-success').should('contain.text', 'Added Row');
  });
});

it('checks job list contains Scheduler and it is running', () => {
  cy.login();
  cy.visit('job/list/');
  cy.get('tr').contains('SchedulerJob').parent().contains('running');
});

it('allows importing variables', () => {
  cy.login();
  cy.visit('variable/list/');
  cy.get('form[action*="varimport"]').within(($form) => {
    cy.get('input[type="file"]').selectFile('cypress/fixtures/variables.json');
    cy.get('button[type="submit"]').click();
  });
  cy.contains('div', 'variable', 'successfully updated');
});
