/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

import { random } from '../support/utils';

it('allows accessing a restricted service (CRD) when API key is presented', () => {
  const ROUTE_PATH = Cypress.env('ingressPath');

  cy.request({
    method: 'GET',
    url: ROUTE_PATH,
    headers: { Host: Cypress.env('ingressHost') },
    failOnStatusCode: false,
  }).then((response) => {
    // No API Key presented
    expect(response.status).to.eq(401);
  });

  cy.request({
    method: 'GET',
    url: ROUTE_PATH,
    headers: {
      apikey: Cypress.env('apikey'),
      Host: Cypress.env('ingressHost'),
    },
  }).then((response) => {
    expect(response.status).to.eq(200);
    expect(response.body).to.contain('Welcome to nginx');
  });
});

it('allows adding a new service and route through admin API', () => {
  // As adminAPI is exposed in another port, we need to use a different base url.
  const BASE_URL = `${Cypress.config('baseUrl')}:${Cypress.env(
    'adminHttpPort'
  )}`;

  cy.fixture('services').then((services) => {
    cy.request({
      method: 'POST',
      url: `${BASE_URL}/services`,
      body: {
        name: `${services.newService.name}-${random}`,
        url: services.newService.upstreamURL,
      },
    }).then((response) => {
      expect(response.status).to.eq(201);
    });

    cy.request({
      method: 'GET',
      url: `${BASE_URL}/services`,
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(JSON.stringify(response.body)).to.contain(services.newService.upstreamURL.replace(/^https?:\/\//, ''));
    });

    cy.fixture('routes').then((routes) => {
      cy.request({
        method: 'POST',
        url: `${BASE_URL}/services/${services.newService.name}-${random}/routes`,
        body: {
          paths: [
            `${routes.newRoute.path}${random}`
          ],
        },
      }).then((response) => {
        expect(response.status).to.eq(201);
      });

      // Changes takes some seconds to apply
      cy.wait(7000);
      cy.request({
        method: 'GET',
        url: `${BASE_URL}/services/${services.newService.name}-${random}/routes`,
      }).then((response) => {
        expect(response.status).to.eq(200);
        expect(JSON.stringify(response.body)).to.contain(`${routes.newRoute.path}${random}`);
      });
    });
  });
});
