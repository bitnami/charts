/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('Can access the API and get the deployed Arango Database status', () => {
  let token;
  // /login returns an API token so we can access
  // other API endpoints
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
          // This is a sample output of /api/deployment
          // {"deployments":[{"name":"vib-arangodb","namespace":"test","mode":"Single","environment":"Development",
          // "state_color":"green","pod_count":1,"ready_pod_count":1,"volume_count":1,"ready_volume_count":1,
          // "storage_classes":[""],"database_url":"","database_version":"3.11.13","database_license":"community"}]}
          //
          // We will check that the name is correct and the status is green
          expect(apiResponse.body.deployments[0].name).to.eq(d.deployment.name);
          expect(apiResponse.body.deployments[0].state_color).to.eq(d.deployment.status);
        });
      }
    });
  });
});
