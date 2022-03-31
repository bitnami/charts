/// <reference types="cypress" />
import {
  random,
} from './utils'

it('allows user to log in and log out', () => {
  cy.login();
  cy.contains('div', 'Invalid user name or password.').should('not.exist');
  cy.contains('button','admin').click();
  cy.contains('a', 'Log Out').click();
  cy.get('.login-group');
})

it('allows creating a project', () => {
  cy.login();
  cy.visit('/harbor/projects');
  cy.fixture('project').then((project) => {
    cy.contains('button','New Project').click();
    cy.get('#create_project_name').type(`${project.name}-${random}`);
    cy.contains('button','OK').should('not.be.disabled').click();
    cy.contains('a',`${project.name}-${random}`);
  });
})

it('allows creating a registry', () => {
  cy.login();
  cy.visit('/harbor/registries');
  cy.fixture('registry').then((registry) => {
    cy.contains('button','New Endpoint').click();
    cy.get('#adapter').select(`${registry.newRegistry.provider}`);
    cy.get('#destination_name').type(`${registry.newRegistry.name}-${random}`);
    cy.contains('button','OK').should('not.be.disabled').click();
    cy.contains('.datagrid-table',`${registry.newRegistry.name}-${random}`);
  });
})

it('allows launching a vulnerability scan', () => {
  const IMAGE_SCANNER = 'Trivy';
  cy.login();
  cy.visit('/harbor/interrogation-services/scanners');
  cy.contains('.datagrid-table',IMAGE_SCANNER);
  cy.contains('a', 'Vulnerability').click();
  cy.contains('button','SCAN NOW').click();
  cy.contains('.alert-item','Trigger scan all successfully!').click();
})

it('checks system configurations endpoint',() => {
  cy.request({
    method: 'GET',
    url: '/api/v2.0/configurations',
    form: true,
    auth: {
      username: Cypress.env("username"),
      password: Cypress.env("password")
    }
  }).as('systemConfig');
  cy.get('@systemConfig').should((response) => {
    expect(response.status).to.eq(200);
    expect(response.body).to.include.all.keys('auth_mode','email_host','project_creation_restriction','scan_all_policy','self_registration');
  })
})
