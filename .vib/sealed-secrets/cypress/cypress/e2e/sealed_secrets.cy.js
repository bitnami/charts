/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('retrives the public certificate correctly', () => {
  cy.request('/v1/cert.pem').then((response) => {
    expect(response.status).to.eq(200);
    expect(response.headers['content-type']).to.eq('application/x-pem-file');
    expect(response.body).to.contain('END CERTIFICATE');
  });
});
