/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('can login and access the experiment run', () => {
  cy.visit('#/experiments/0', {
    auth: {
      username: Cypress.env('username'),
      password: Cypress.env('password'),
    },
    failOnStatusCode: false,
  });
  // HACK: This approach is not recommended by Cypress but there is no clear way to
  // workaround the following race condition. In some test runs, the `run` Job
  // (check runtime-parameters.yaml) has not finished executing and therefore
  // it is not visible in the UI. In this case, we would need to reload the page
  // to see if the run is there or not. There is discussion in the Cypress repo on how to
  // workaround that: https://github.com/cypress-io/cypress/issues/3757
  cy.contains('Evaluation');
  const max_attempts = 5;
  let runFound = false;
  for (let i = 0; i < max_attempts && !runFound; i += 1)
  cy.get('body').then(($body) => {
    if ($body.find('a[href*="runs"]').length === 0) {
      // run job has not finished executing, so we wait and reload the page
      cy.wait(5000);
      cy.reload();
    } else {
      runFound = true;
    }
  });
  cy.get('a[href*="runs"]').first().click();
  cy.fixture('scripts').then((script) => {
    // This ensures that the script in the job was run
    cy.contains(script.script.title);
    // This ensures that the communication with MinIO succeeded
    cy.contains('Artifacts').click();
    cy.contains(script.script.modelFile);
  });
});
