/// <reference types="cypress" />
import {
  deleteDashboard,
  deleteAPIKey,
  clickDeleteButton,
  verifySuccesOfAction
} from './utils'

it('allows user to log out', () => {
  cy.login();
  cy.visit('/logout');
  cy.get('.login-content-box').should('exist');
})

it('allows creating a dashboard with a panel', () => {
  const CLOSE_DIALOGUE_BUTTON = 'button[aria-label="Close dialogue"]';

  cy.login();
  cy.visit('dashboard/new');
  cy.get('button').contains('Add a new panel')
    .should('be.visible').click();
  cy.get('[value="Panel Title"]').clear().type(Cypress.env('panel_title'));
  cy.get('textarea#description-text-area')
    .should('exist').type(Cypress.env('panel_description'));
  cy.get('button').contains('Apply')
    .should('be.visible').click();
  cy.get('.panel-title').contains(Cypress.env('panel_title'));
  cy.get('[aria-label="Save dashboard"]').click();
  cy.get(CLOSE_DIALOGUE_BUTTON)
    .should('be.visible');
  cy.get('[name="title"]').clear().type(Cypress.env('dashboard_title'));
  cy.get('[type="submit"]')
    .should('be.visible').click();
  verifySuccesOfAction();
  deleteDashboard();
})

it('checks if it is possible to upload a dashboard as JSON file', () => {
  const IMPORT_DASHBOARD_BUTTON = '[data-testid="data-testid-import-dashboard-submit"]';
  
  cy.login();
  cy.visit("dashboard/import");
  cy.get('label').contains('Upload JSON').click();
  cy.get('input[type=file]').selectFile('cypress/fixtures/test-dashboard.json',
  {force:true});
  cy.get(IMPORT_DASHBOARD_BUTTON).click();
  cy.visit("dashboards");
  cy.get('div').contains('New test dashboard')
    .should('exist').click();
  deleteDashboard();
})

it('allows inviting a user', () => {
  cy.login();
  cy.visit('/org/users/invite');
  cy.get('[name="loginOrEmail"]').clear().type(Cypress.env('test_email_address'));
  cy.get('[name="name"]').clear().type(Cypress.env('invite_user_name'));
  cy.get('[name="sendEmail"]').click({force: true});
  cy.get('[type="submit"]').click();
  verifySuccesOfAction();
})

it('checks if smtp is configured', () => {
  cy.login();
  cy.visit("admin/settings");
  cy.get('td').contains(Cypress.env('smtp_address'))
    .should('exist');
  cy.get('td').contains(Cypress.env('smtp_name'))
    .should('exist');
  cy.get('td').contains(Cypress.env('smtp_user'))
    .should('exist');
})

it('checks if plugin page is showing plugins', () => {
  cy.login();
  cy.visit('/plugins?filterByType=datasource');
  cy.get('[data-testid="plugin-list"]')
    .should('exist');
})

it('checks if it is possible to create and delete a data source', () => {
  const DATASOURCE = 'Prometheus';
  const DATASOURCE_ID = 'button[aria-label= "Add data source ' + DATASOURCE + '"]'

  cy.login();
  cy.visit("/datasources/new");
  cy.get('input[placeholder="Filter by name or type"]')
    .type(DATASOURCE);
  cy.get(DATASOURCE_ID).click();
  cy.get('div').contains('Datasource added')
    .should('be.visible');
  cy.visit("/datasources");
  cy.get('div').contains(DATASOURCE).click();
  cy.get('button').contains('Delete').click();
  cy.get('div').contains('Are you sure you want to delete')
    .should('be.visible');
  clickDeleteButton();
  verifySuccesOfAction();
})

it('checks if an API key can be added', () => {
  const ADD_NEW_API_KEY = '[data-testid="data-testid Call to action button New API key"]';

  cy.login();
  cy.visit('org/apikeys');
  cy.get(ADD_NEW_API_KEY).click();
  cy.get('input[placeholder="Name"]')
    .should('be.visible').type("test")
  cy.get('button').contains('Add').click({force:true});
  cy.get('h2').contains('API Key Created')
    .should('be.visible');
  deleteAPIKey();
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
