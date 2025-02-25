/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('Can access the API and get the deployed Arango Database status', () => {
  let token;
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
  }).then(() => {
    // In order to avoid a race condition, we wait 60 seconds to ensure that the
    // Arango database is fully deployed and available
    cy.wait(60000);
    cy.request({
      method: 'GET',
      url: '/api/deployment',
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    }).then((apiResponse) => {
      expect(apiResponse.status).to.eq(200);
      if (apiResponse.body.deployments[0]) {
        cy.fixture('deployments').then((d) => {
          // This ensures that the script in the job was run
          expect(apiResponse.body.deployments[0].name).to.eq(d.deployment.name);
          expect(apiResponse.body.deployments[0].state_color).to.eq('green');
        });
      }
    });
  });
});
