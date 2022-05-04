/// <reference types="cypress" />
import { random } from './utils';

it('allows admin to login/logout', () => {
  cy.login();
  cy.get('#flash_error').should('not.exist');
  cy.contains('Sign out').click();
  cy.contains('Sign in');
});

it('allows user to register', () => {
  cy.contains('Register').click();
  cy.fixture('users').then((user) => {
    cy.get('#user_login').type(`${user.newUser.userName}.${random}`);
    cy.get('#user_password').type(`${user.newUser.password}.${random}`);
    cy.get('#user_password_confirmation').type(
      `${user.newUser.password}.${random}`
    );
    cy.get('#user_firstname').type(`${user.newUser.firstName}.${random}`);
    cy.get('#user_lastname').type(`${user.newUser.lastName}.${random}`);
    cy.get('#user_mail').type(`${user.newUser.email}.${random}@email.com`);
  });
  cy.get('[type="submit"]').click();
  cy.contains('Your account was created');
});

it('allows admin to create a project and an issue with file uploaded', () => {
  cy.login();
  cy.contains('Projects').click();
  cy.contains('New project').click();
  cy.fixture('projects').then((project) => {
    cy.get('#project_name').type(`${project.newProject.name}.${random}`);
    cy.get('#project_description').type(project.newProject.description);
    cy.get('[name="commit"]').click();
    cy.contains('Successful creation.');
    cy.contains('Projects').click();
    cy.contains('.project', `${project.newProject.name}.${random}`).click();
  });
  cy.contains('Issues').click();
  cy.get('.icon-add').click();
  cy.fixture('issues').then((issue) => {
    cy.get('#issue_subject').type(`${issue.newIssue.subject}.${random}`);
    cy.get('#issue_description').type(issue.newIssue.description);
    cy.get('input[type="file"]').selectFile('cypress/fixtures/issues.json');
  });
  cy.get('[name="commit"]').click();
  cy.contains('#flash_notice', 'created');
  cy.contains('issues.json');
});

it('allows admin to create a new role', () => {
  cy.login();
  cy.visit('/admin');
  cy.contains('Roles and permissions').click();
  cy.get('.icon-add').click();
  cy.fixture('roles').then((role) => {
    cy.get('#role_name').type(`${role.QA.name}.${random}`);
  });
  cy.get('[type="submit"]').scrollIntoView().click();
  cy.contains('#flash_notice', 'Successful creation.');
});

it('allows admin to verify and change application configuration', () => {
  cy.login();
  cy.visit('/admin');
  cy.contains('Settings').click();
  cy.get('#settings_app_title').clear().type(`VMWare.${random}`);
  cy.contains('input', 'Save').click();
  cy.contains('#flash_notice', 'Successful update.');
  cy.visit('/admin/info');
  cy.contains('Mysql');
  cy.contains('production');
  cy.contains('Git');
});
