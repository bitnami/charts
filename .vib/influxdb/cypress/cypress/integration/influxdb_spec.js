/// <reference types="cypress" />
import { random } from '../support/utils';

it('can create a new bucket', () => {
  cy.login();
  cy.visitInOrg('/load-data/buckets');
  cy.get('[data-testid="Create Bucket"]').click();
  cy.fixture('buckets').then((buckets) => {
    cy.get('[data-testid="bucket-form-name"]').type(
      `${buckets.newBucket.name}-${random}`
    );
    cy.get('[data-testid="bucket-form-submit"]').click();
    cy.get(`[data-testid="bucket-card ${buckets.newBucket.name}-${random}"]`);
  });
});

it('allows to import and visualize new data to DB', () => {
  const MAX_SAMPLE_VALUE = '2.43';
  cy.login();

  // Import sample data into the DB
  cy.visitInOrg('/load-data/sources');
  cy.get('[data-testid="load-data-item lp"]').click();
  cy.contains('[data-testid="list-item"]', Cypress.env('bucket')).click();
  cy.get('[type="file"]').selectFile(
    'cypress/fixtures/sample_data/glucose_levels.txt',
    { force: true }
  );
  cy.get('[data-testid="write-data--button"]').click();
  cy.contains('Written Successfully');

  // Import a preconfigured dashboard to visualize sample data
  cy.visitInOrg('/dashboards-list/');
  cy.get('[data-testid="add-resource-dropdown--button"]').click();
  cy.get('[data-testid="add-resource-dropdown--import"]').click();
  const newDashboard = 'cypress/fixtures/dashboards/health_tracker.json';
  cy.readFile(newDashboard).then((obj) => {
    obj.content.data.attributes.name = `Health Tracker ${random}`;
    cy.writeFile(newDashboard, obj);
  });
  cy.get('[type="file"]').selectFile(newDashboard, { force: true });
  cy.get('[data-testid="submit-button Dashboard"]').click();
  cy.contains('Successfully imported');
  cy.visitInOrg('/dashboards-list');
  cy.contains(`Health Tracker ${random}`).click();
  cy.contains(MAX_SAMPLE_VALUE);
});
