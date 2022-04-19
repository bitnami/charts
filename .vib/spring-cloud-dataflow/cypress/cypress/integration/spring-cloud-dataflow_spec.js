/// <reference types="cypress" />

// it('allows accesing the dashboard', () => {
//   cy.visit('/');
//   cy.get('.signpost-trigger').click();
//   cy.get('.signpost-content-body').should('contain', 'Version');
// });

// it('allows importing an application ', () => {
//   cy.visit('/');
//   cy.contains('button', 'Add application(s)').click();
//   cy.contains(
//     '.clr-control-label',
//     'Stream application starters for Kafka/Maven'
//   ).click();
//   cy.get('.btn-primary').click();
//   cy.get('.toast-container').should('contain', 'Application(s) Imported');
//   cy.get('.content-area')
//     .should('contain', 'processor')
//     .and('contain', 'sink')
//     .and('contain', 'source');
// });

it('allows creating a stream', () => {
  cy.visit('/');
  cy.get('[routerlink="streams/list"').click();
  cy.contains('.btn-primary', 'Create stream(s)').click();
});

it('allows creating a task', () => {
  cy.visit('/');
  cy.get('[routerlink="tasks-jobs/tasks"]').click();
  cy.contains('.btn-primary', 'Create task').click();
});
