/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows adding a user', () => {
  cy.login();
  cy.visit('/admin/users');
  cy.fixture('users').then((users) => {
    cy.contains('Create User').click();
    cy.get('#create-user-login').type(`${users.newUser.loginName}${random}`);
    cy.get('#create-user-name').type(`${users.newUser.fullName} ${random}`);
    cy.get('#create-user-password').type(users.newUser.password);
    cy.get('button[type="submit"]').contains('Create').click();
    cy.visit('/admin/users');
    cy.contains(`${users.newUser.fullName} ${random}`);
  });
});

it('allows adding a project', () => {
  cy.login();
  cy.visit('/admin/projects_management');
  cy.fixture('projects').then((projects) => {
    cy.contains('Create Project').click();
    cy.get('#create-project-name').type(`${projects.newProject.name} ${random}`);
    cy.get('#create-project-key').type(`${projects.newProject.key}${random}`);
    cy.get('button[type="submit"]').contains('Create').click();
    cy.visit('/admin/projects_management');
    cy.contains(`${projects.newProject.name} ${random}`);
  });
});

it('checks the search engine status', () => {
  cy.login();
  cy.visit('/admin/system?expand=Search+Engine');
  cy.get('table[id="Search State"]').contains('Status is up');
});
