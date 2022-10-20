/// <reference types="cypress" />

it('allows executing a query and displaying response data', () => {
  const query = 'alertmanager_alerts';

  cy.visit(`/graph`);
  cy.get('[role="textbox"]').type(query);
  cy.contains('Execute').click();
  cy.contains('.data-table', `${query}{container="alertmanager"`)
});

it('allows checking targets status', () => {
  const pods = Cypress.env('pods');

  Object.keys(pods).forEach((podName, i) => {
    const podData = Object.values(pods)[i];

    cy.visit(`/targets?search=${podName}`);
    cy.contains(`${podData.replicaCount}/${podData.replicaCount} up`);
  })
});
