/// <reference types="cypress" />
import { random, verifySuccesOfAction } from '../support/utils';

it('allows user to log in and log out', () => {
  cy.login();
  cy.contains('div', 'Invalid username').should('not.exist');
  cy.visit('/logout');
  cy.contains('.login-content-box', 'Welcome to Grafana');
});

it('allows creating a dashboard with a panel', () => {
  cy.login();
  cy.visit('dashboard/new');
  cy.contains('button', 'Add a new panel').click();

  cy.fixture('panels').then((panel) => {
    cy.get('[value*="Panel Title"]')
      .clear()
      .type(`${panel.newPanel.title} ${random}`);
    cy.get('textarea#description-text-area').type(
      `${panel.newPanel.description} ${random}`
    );
    cy.contains('button', 'Apply').click();
    cy.contains('.panel-title', `${panel.newPanel.title} ${random}`);
  });

  cy.get('[aria-label*="Save dashboard"]').click();
  cy.fixture('dashboards').then((dashboard) => {
    cy.get('[name*="title"]')
      .clear()
      .type(`${dashboard.newDashboard.title} ${random}`);
  });
  cy.get('[type*="submit"]').click();
  verifySuccesOfAction();
});

it('checks if it is possible to upload a dashboard as JSON file', () => {
  cy.login();
  cy.visit('dashboard/import');
  cy.contains('label', 'Upload JSON').click();
  cy.get('input[type=file]').selectFile(
    'cypress/fixtures/test-dashboard.json',
    { force: true }
  );

  cy.fixture('dashboards').then((dashboard) => {
    cy.get('[data-testid*="data-testid-import-dashboard-title"]')
      .clear()
      .type(`${dashboard.newDashboard.uploadedTitle} ${random}`);
    cy.get('[data-testid*="data-testid-import-dashboard-submit"]').click();
    cy.visit('dashboards');
    cy.get(
      'input[aria-label*="View as list"]'
    ).click({ force: true });
    cy.contains('div', `${dashboard.newDashboard.uploadedTitle} ${random}`);
  });
});

it('allows inviting a user', () => {
  cy.login();
  cy.visit('/org/users/invite');
  cy.fixture('users').then((user) => {
    cy.get('[name*="loginOrEmail"]')
      .clear()
      .type(`${user.newUser.email}.${random}`);
    cy.get('[name*="name"]').clear().type(`${user.newUser.userName}.${random}`);
  });

  cy.get('[name*="sendEmail"]').click({ force: true });
  cy.get('[type*="submit"]').click();
  verifySuccesOfAction();
});

it('checks if smtp is configured', () => {
  cy.login();
  cy.visit('admin/settings');
  cy.fixture('smtps').then((smtp) => {
    cy.contains('td', smtp.newSMTPConfig.email);
    cy.contains('td', smtp.newSMTPConfig.name);
    cy.contains('td', smtp.newSMTPConfig.user);
  });
});

it('checks if plugin page is showing plugins', () => {
  cy.login();
  cy.visit('/plugins?filterByType=datasource');
  cy.get('[data-testid*="plugin-list"]');
});

it('checks if it is possible to create and delete a data source', () => {
  cy.login();
  cy.visit('/datasources/new');
  cy.fixture('datasources').then((datasource) => {
    cy.get('input[placeholder*="Filter by name or type"]').type(
      datasource.newDatasource.name
    );
    cy.get(
      `button[aria-label*="Add data source ${datasource.newDatasource.name}"]`
    ).click();
    cy.contains('div', 'Datasource added');
    cy.visit('/datasources');
    cy.contains('a', datasource.newDatasource.name).click({ force: true });
  });
  cy.contains('button', 'Delete').click();
  cy.contains('div', 'Are you sure you want to delete');
  cy.get('button[aria-label*="Confirm Modal Danger Button"]').click();
  verifySuccesOfAction();
});

it('checks if an API key can be added and deleted', () => {
  cy.login();
  cy.visit('org/apikeys');
  cy.get(
    '[data-testid*="data-testid Call to action button New API key"]'
  ).click();
  cy.fixture('apikeys').then((apikey) => {
    cy.get('input[placeholder*="Name"]').type(
      `${apikey.newAPIKey.name}.${random}`
    );
  });
  cy.contains('button', 'Add').click({ force: true });
  cy.contains('h2', 'API Key Created');
  cy.get('button[aria-label*="Close dialogue"]').click();
  cy.get('button[aria-label*="Delete API key"]').click();
  cy.contains('span', 'Delete').click();
});

it('checks admin settings endpoint', () => {
  cy.request({
    method: 'GET',
    url: '/api/admin/settings',
    form: true,
    auth: {
      username: Cypress.env('username'),
      password: Cypress.env('password'),
    },
  }).as('adminSettings');
  cy.get('@adminSettings').should((response) => {
    expect(response.status).to.eq(200);
    expect(response.body).to.include.all.keys(
      'DEFAULT',
      'alerting',
      'analytics',
      'security',
      'smtp'
    );
  });
});

it('checks the usage preview endpoint', () => {
  cy.request({
    method: 'GET',
    url: 'api/admin/usage-report-preview',
    form: true,
    auth: {
      username: Cypress.env('username'),
      password: Cypress.env('password'),
    },
  }).as('usagePreview');
  cy.get('@usagePreview').should((response) => {
    expect(response.status).to.eq(200);
    expect(response.body).to.include.all.keys('metrics', 'version');
  });
});
