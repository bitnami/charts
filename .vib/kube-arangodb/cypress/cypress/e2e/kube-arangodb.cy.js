/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('can access the script run and cluster status', () => {
  cy.login();
  // HACK: This approach is not recommended by Cypress but there is no clear way to
  // workaround the following race condition. In some test runs, the ArangoDeployment
  // has not finished deployming and therefore it is not visible in the UI. In this case, we would need to reload the page
  // to see if the run is there or not. There is discussion in the Cypress repo on how to
  // workaround that: https://github.com/cypress-io/cypress/issues/3757
  cy.contains('Deployments');
  const max_attempts = 5;
  let runFound = false;
  for (let i = 0; i < max_attempts && !runFound; i += 1)
  cy.get('body').then(($body) => {
    if ($body.find('i.green').length === 0) {
      // run job has not finished executing, so we wait and reload the page
      cy.wait(5000);
      cy.reload();
    } else {
      runFound = true;
    }
  });
  cy.fixture('deployments').then((d) => {
    // This ensures that the script in the job was run
    cy.contains(d.deployment.name);
  });
});
