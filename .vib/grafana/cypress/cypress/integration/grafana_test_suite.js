/// <reference types="cypress" />
import {
<<<<<<< HEAD
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
=======
  random,
  verifySuccesOfAction
} from './utils'

it('allows user to log in and log out', () => {
  cy.login();
  cy.contains('div', 'Invalid username').should('not.exist');
  cy.visit('/logout');
  cy.get('.login-content-box').should('be.visible');
})

it('allows creating a dashboard with a panel', () => {
  const PANEL_TITLE = 'Test panel title';
  const PANEL_DESCRIPTION = 'Test panel description';
  const DASHBOARD_TITLE = 'Dashboard title';

  cy.login();
  cy.visit('dashboard/new');
  cy.contains('button', 'Add a new panel')
    .should('be.visible').click();
  cy.get('[value*="Panel Title"]').clear().type(`${PANEL_TITLE}.${random}`);
  cy.get('textarea#description-text-area')
    .should('exist').type(`${PANEL_DESCRIPTION}.${random}`);

  cy.contains('button','Apply')
    .should('be.visible').click();

  cy.contains('.panel-title', PANEL_TITLE).should('be.visible');
  cy.get('[aria-label*="Save dashboard"]').click();
  cy.get('button[aria-label*="Close dialogue"]')
    .should('be.visible');
  cy.get('[name*="title"]').clear().type(`${DASHBOARD_TITLE}.${random}`);
  cy.get('[type*="submit"]')
    .should('be.visible').click();
  verifySuccesOfAction();
})

it('checks if it is possible to upload a dashboard as JSON file', () => {
  const DASHBOARD_TITLE = 'New Test dashboard';

  cy.login();
  cy.visit('dashboard/import');
  cy.contains('label','Upload JSON').click();
  cy.get('input[type=file]').selectFile('cypress/fixtures/test-dashboard.json',
  {force:true});
  cy.get('[data-testid*="data-testid-import-dashboard-title"]').clear().type(`${DASHBOARD_TITLE}.${random}`);
  cy.get('[data-testid*="data-testid-import-dashboard-submit"]').click();
  cy.visit("dashboards");
  cy.contains('div', DASHBOARD_TITLE)
    .should('exist').click();
})

it('allows inviting a user', () => {
  const TEST_EMAIL_ADDRESS = 'test@email.com';
  const INVITE_USER_NAME = 'Invited test user';

  cy.login();
  cy.visit('/org/users/invite');
  cy.get('[name*="loginOrEmail"]').clear().type(`${TEST_EMAIL_ADDRESS}.${random}`);
  cy.get('[name*="name"]').clear().type(`${INVITE_USER_NAME}.${random}`);
  cy.get('[name*="sendEmail"]').click({force: true});
  cy.get('[type*="submit"]').click();
>>>>>>> bitnami-master
  verifySuccesOfAction();
})

it('checks if smtp is configured', () => {
<<<<<<< HEAD
  cy.login();
  cy.visit("admin/settings");
  cy.get('td').contains(Cypress.env('smtp_address'))
    .should('exist');
  cy.get('td').contains(Cypress.env('smtp_name'))
    .should('exist');
  cy.get('td').contains(Cypress.env('smtp_user'))
=======
  const SMTP_ADDRESS = 'test@smtp.com';
  const SMTP_NAME = 'test_smtp';
  const SMTP_USER = 'smtp_user';

  cy.login();
  cy.visit('admin/settings');
  cy.contains('td', SMTP_ADDRESS)
    .should('exist');
  cy.contains('td', SMTP_NAME)
    .should('exist');
  cy.contains('td', SMTP_USER)
>>>>>>> bitnami-master
    .should('exist');
})

it('checks if plugin page is showing plugins', () => {
  cy.login();
  cy.visit('/plugins?filterByType=datasource');
<<<<<<< HEAD
  cy.get('[data-testid="plugin-list"]')
=======
  cy.get('[data-testid*="plugin-list"]')
>>>>>>> bitnami-master
    .should('exist');
})

it('checks if it is possible to create and delete a data source', () => {
  const DATASOURCE = 'Prometheus';
<<<<<<< HEAD
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
=======

  cy.login();
  cy.visit('/datasources/new');
  cy.get('input[placeholder*="Filter by name or type"]')
    .type(DATASOURCE);
  cy.get(`button[aria-label*="Add data source ${DATASOURCE}"]`).click();
  cy.contains('div', 'Datasource added')
    .should('be.visible');
    cy.visit("/datasources");
    cy.contains('a', DATASOURCE).click({force:true});
    cy.contains('button', 'Delete').click();
    cy.contains('div', 'Are you sure you want to delete')
      .should('be.visible');
    cy.get('button[aria-label*="Confirm Modal Danger Button"]').should('be.visible').click();
    verifySuccesOfAction();
})

it('checks if an API key can be added and deleted', () => {
  const API_KEY_NAME = 'test_api_key';

  cy.login();
  cy.visit('org/apikeys');
  cy.get('[data-testid*="data-testid Call to action button New API key"]').click();
  cy.get('input[placeholder*="Name"]')
    .should('be.visible').type(`${API_KEY_NAME}.${random}`)
  cy.contains('button', 'Add').click({force:true});
  cy.contains('h2', 'API Key Created')
    .should('be.visible');
  cy.get('button[aria-label*="Close dialogue"]').click();
  cy.get('button[aria-label*="Delete API key"]').click();
  cy.contains('span', 'Delete').click();
>>>>>>> bitnami-master
})

it('checks admin settings endpoint',() => {
  cy.request({
    method: 'GET',
    url: '/api/admin/settings',
<<<<<<< HEAD
    form: true, 
=======
    form: true,
>>>>>>> bitnami-master
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
<<<<<<< HEAD
    form: true, 
=======
    form: true,
>>>>>>> bitnami-master
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
<<<<<<< HEAD
  
=======
>>>>>>> bitnami-master
