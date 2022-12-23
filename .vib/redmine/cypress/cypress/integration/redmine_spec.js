/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows admin to login/logout', () => {
  cy.login();
  cy.contains('#flash_error').should('not.exist');
  cy.contains('Sign out').click();
  cy.contains('Sign in');
});

it('allows user to register', () => {
  cy.visit('/account/register');
  cy.fixture('users').then((user) => {
    cy.get('#user_login').type(`${user.newUser.userName}.${random}`);
    cy.get('#user_password').type(`${user.newUser.password}.${random}`);
    cy.get('#user_password_confirmation').type(
      `${user.newUser.password}.${random}`
    );
    cy.get('#user_firstname').type(`${user.newUser.firstName}.${random}`);
    cy.get('#user_lastname').type(`${user.newUser.lastName}.${random}`);
    cy.get('#user_mail').type(`.${random}${user.newUser.email}`);
  });
  cy.get('[type="submit"]').click();
  cy.contains('Your account was created');
});

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
    cy.get('input[type="file"]').selectFile('cypress/fixtures/issues.json');
  });
  cy.get('[name="commit"]').click();
  cy.contains('#flash_notice', 'created');
  cy.contains('issues.json');
});

it('allows admins to verify SMTP is enabled and modify it', () => {
  cy.login();
  cy.visit('/settings?tab=notifications');
  cy.fixture('smtps').then((smtp) => {
    cy.get('#settings_mail_from')
      .clear()
      .type(`${smtp.newSMTP.smtpEmailAddress}.${random}`);
    cy.get('#settings_emails_header')
      .scrollIntoView()
      .clear()
      .type(`${smtp.newSMTP.header}.${random}`);
    cy.get('#settings_emails_footer')
      .clear()
      .type(`${smtp.newSMTP.footer}.${random}`);
  });
  cy.contains('[type="submit"]', 'Save').click({ force: true });
  cy.contains('Successful update');
});

it('allows admin to modify and observe application configuration', () => {
  cy.login();
  cy.visit('/admin');
  cy.contains('Settings').click();
  cy.fixture('settings').then((setting) => {
    cy.get('#settings_app_title')
      .clear()
      .type(`${setting.newSetting.appTitle}.${random}`);

    cy.contains('input', 'Save').click();
    cy.contains('#flash_notice', 'Successful update');
    cy.visit('/admin/info');
    cy.contains(setting.newSetting.database);
    cy.contains(setting.newSetting.environment);
    cy.contains(setting.newSetting.versionControl);
  });
});
