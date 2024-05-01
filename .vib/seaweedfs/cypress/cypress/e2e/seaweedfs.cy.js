/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('allows obtaining cluster status from Master Server', () => {
  cy.request('/cluster/status').then((response) => {
    expect(response.status).to.eq(200);
    expect(response.body).to.have.property('Leader');
  });
});
