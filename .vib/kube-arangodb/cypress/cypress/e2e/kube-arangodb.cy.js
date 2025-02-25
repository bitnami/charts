/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('can access the script run and cluster status', () => {
  let token;
  let deploymentFound = false;

  cy.request({
    method: 'POST',
    url: '/login',
    body: {
      username: Cypress.env('username'),
      password: Cypress.env('password'),
    },
  }).then((response) => {
    expect(response.status).to.eq(200);
    token = response.body.token;
  });
  cy.then(() => {
    cy.wait(20000);
    cy.request({
      method: 'GET',
      url: '/api/deployment',
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    }).then((apiResponse) => {
      expect(apiResponse.status).to.eq(200);
      if (apiResponse.body.deployments[0]) {
        deploymentFound = true;
        cy.fixture('deployments').then((d) => {
          // This ensures that the script in the job was run
          expect(apiResponse.body.deployments[0].name).to.eq(d.deployment.name);
        });
      }
    });
  });
  cy.then(() => {
    expect(deploymentFound).to.be.true;
  })
});
