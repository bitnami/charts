/// <reference types="cypress" />
import {
  random,
  verifySuccesOfAction
} from './utils'

it('allows user to log in and log out', () => {
  cy.login();
  cy.get('div').contains('Invalid username').should('not.exist');
  cy.visit('/logout');
  cy.get('.login-content-box').should('be.visible');
})

it('allows creating a dashboard with a panel', () => {
  const CLOSE_DIALOGUE_BUTTON = 'button[aria-label="Close dialogue"]';
  const PANEL_TITLE = 'Test panel title';
  const PANEL_DESCRIPTION = 'Test panel description';
  const DASHBOARD_TITLE = 'Dashboard title';

  cy.login();
  cy.visit('dashboard/new');
  cy.get('button').contains('Add a new panel')
    .should('be.visible').click();
  cy.get('[value="Panel Title"]').clear().type(`${PANEL_TITLE}.${random}`);
  cy.get('textarea#description-text-area')
    .should('exist').type(`${PANEL_DESCRIPTION}.${random}`);
  cy.get('button').contains('Apply')
    .should('be.visible').click();
  cy.get('.panel-title').contains(PANEL_TITLE).should('be.visible');
  cy.get('[aria-label="Save dashboard"]').click();
  cy.get(CLOSE_DIALOGUE_BUTTON)
    .should('be.visible');
  cy.get('[name="title"]').clear().type(`${DASHBOARD_TITLE}.${random}`);
  cy.get('[type="submit"]')
    .should('be.visible').click();
  verifySuccesOfAction();
})

it('checks if it is possible to upload a dashboard as JSON file', () => {
  const IMPORT_DASHBOARD_BUTTON = '[data-testid="data-testid-import-dashboard-submit"]';
  const DASHBOARD_TITLE = "New Test dashboard";
  
  cy.login();
  cy.visit("dashboard/import");
  cy.get('label').contains('Upload JSON').click();
  cy.get('input[type=file]').selectFile('cypress/fixtures/test-dashboard.json',
  {force:true});
  cy.get('[data-testid="data-testid-import-dashboard-title"]').clear().type(`${DASHBOARD_TITLE}.${random}`);
  cy.get(IMPORT_DASHBOARD_BUTTON).click();
  cy.visit("dashboards");
  cy.get('div').contains(DASHBOARD_TITLE)
    .should('exist').click();
})

it('allows inviting a user', () => {
  const TEST_EMAIL_ADDRESS = 'test@email.com';
  const INVITE_USER_NAME = 'Invited test user';

  cy.login();
  cy.visit('/org/users/invite');
  cy.get('[name="loginOrEmail"]').clear().type(`${TEST_EMAIL_ADDRESS}.${random}`);
  cy.get('[name="name"]').clear().type(`${INVITE_USER_NAME}.${random}`);
  cy.get('[name="sendEmail"]').click({force: true});
  cy.get('[type="submit"]').click();
  verifySuccesOfAction();
})

it('checks if smtp is configured', () => {
  const SMTP_ADDRESS = 'test@smtp.com';
  const SMTP_NAME = 'test_smtp';
  const SMTP_USER = 'smtp_user';

  cy.login();
  cy.visit("admin/settings");
  cy.get('td').contains(SMTP_ADDRESS)
    .should('exist');
  cy.get('td').contains(SMTP_NAME)
    .should('exist');
  cy.get('td').contains(SMTP_USER)
    .should('exist');
})

it('checks if plugin page is showing plugins', () => {
  cy.login();
  cy.visit('/plugins?filterByType=datasource');
  cy.get('[data-testid="plugin-list"]')
    .should('exist');
})

it('checks if it is possible to create a data source', () => {
  const DATASOURCE = 'Prometheus';
  const DATASOURCE_ID = 'button[aria-label= "Add data source ' + DATASOURCE + '"]'

  cy.login();
  cy.visit("/datasources/new");
  cy.get('input[placeholder="Filter by name or type"]')
    .type(DATASOURCE);
  cy.get(DATASOURCE_ID).click();
  cy.get('div').contains('Datasource added')
    .should('be.visible');
})

it('checks if an API key can be added and deleted', () => {
  const ADD_NEW_API_KEY = '[data-testid="data-testid Call to action button New API key"]';
  const API_KEY_NAME = "test_api_key";
  const CLOSE_DIALOGUE_BUTTON = 'button[aria-label="Close dialogue"]';
  const DELETE_API_KEY_BUTTON = 'button[aria-label="Delete API key"]';

  cy.login();
  cy.visit('org/apikeys');
  cy.get(ADD_NEW_API_KEY).click();
  cy.get('input[placeholder="Name"]')
    .should('be.visible').type(`${API_KEY_NAME}.${random}`)
  cy.get('button').contains('Add').click({force:true});
  cy.get('h2').contains('API Key Created')
    .should('be.visible');
  cy.get(CLOSE_DIALOGUE_BUTTON).click();
  cy.get(DELETE_API_KEY_BUTTON).click();
  cy.get('span').contains('Delete').click();
})

it('checks admin settings endpoint',() => {
  cy.request({
    method: 'GET',
    url: '/api/admin/settings',
    form: true, 
    auth: {
      username: Cypress.env("username"),
      password: Cypress.env("password")
    }
  }).as('adminSettings');
  cy.get('@adminSettings').should((response) => {
    expect(response.status).to.eq(200);
    expect(response.body).to.include.all.keys('DEFAULT','alerting', 'analytics','security','smtp');
  })
})

it('checks the usage preview endpoint',() => {
    cy.request({
    method: 'GET',
    url: 'api/admin/usage-report-preview',
    form: true, 
    auth: {
      username: Cypress.env("username"),
      password: Cypress.env("password")
    }
  }).as('usagePreview');
  cy.get('@usagePreview').should((response) => {
    expect(response.status).to.eq(200);
    expect(response.body).to.include.all.keys('metrics','version');
   })
 })
  