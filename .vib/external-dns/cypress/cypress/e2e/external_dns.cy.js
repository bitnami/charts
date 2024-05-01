/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('can check metrics endpoint', () => {
  cy.request({
    method: 'GET',
    url: '/metrics',
    form: true,
  }).then((response) => {
    expect(response.status).to.eq(200);
    expect(response.body).to.contain('external_dns_registry_a_records');
  });
});
