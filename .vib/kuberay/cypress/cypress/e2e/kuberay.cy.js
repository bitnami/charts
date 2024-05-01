/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('can access the script run and cluster status', () => {
  cy.visit('/');
  // HACK: This approach is not recommended by Cypress but there is no clear way to
  // workaround the following race condition. In some test runs, the Job
  // (check runtime-parameters.yaml) has not finished executing and therefore
  // it is not visible in the UI. In this case, we would need to reload the page
  // to see if the run is there or not. There is discussion in the Cypress repo on how to
  // workaround that: https://github.com/cypress-io/cypress/issues/3757
  cy.contains('Recent jobs');
  const max_attempts = 5;
  let runFound = false;
  for (let i = 0; i < max_attempts && !runFound; i += 1)
  cy.get('body').then(($body) => {
    if ($body.find('a[href*="/jobs/"]').length === 0) {
      // run job has not finished executing, so we wait and reload the page
      cy.wait(5000);
      cy.reload();
    } else {
      runFound = true;
    }
  });
  cy.fixture('scripts').then((script) => {
    // This ensures that the script in the job was run
    cy.contains(script.script.title);
  });
  // Check the cluster status
  cy.contains('a', 'Cluster').click();
  cy.fixture('clusters').then((cluster) => {
    // This ensures the cluster is well formed
    cy.contains(cluster.cluster.head);
    cy.contains(cluster.cluster.worker);
  });
});
