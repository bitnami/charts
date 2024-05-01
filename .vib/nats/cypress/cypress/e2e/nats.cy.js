/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('allows to check general config endpoint', () => {
  cy.request({
    method: 'GET',
    url: '/varz',
    form: true,
  }).then((response) => {
    expect(response.status).to.eq(200);
    expect(response.body.port).to.eq(Cypress.env('containerPorts').client);
    expect(response.body.http_port).to.eq(Cypress.env('containerPorts').monitoring);
    expect(response.body.cluster.cluster_port).to.eq(Cypress.env('containerPorts').cluster);
    expect(response.body.connect_urls).to.have.length(Cypress.env('replicaCount'));
  });
});
